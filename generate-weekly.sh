#!/bin/bash
# Weekly AI News Summary Generator
# Aggregates the week's daily summaries into a weekly rollup

set -e

REPO_DIR="/home/node/.openclaw/workspace/ai-news"
YEAR=$(date +%Y)
WEEK=$(date +%V)
WEEK_ID="${YEAR}-W${WEEK}"
FILENAME="${REPO_DIR}/weekly/${WEEK_ID}.md"

cd "$REPO_DIR"

echo "🔍 Generating weekly summary for Week ${WEEK}, ${YEAR}..."

# Get the week's date range
WEEK_START=$(date -d "${YEAR}-01-01 +$(($(date +%u)-1)) days +$((${WEEK}-1)) weeks" +%Y-%m-%d 2>/dev/null || date -d "monday" +%Y-%m-%d)
WEEK_END=$(date -d "${WEEK_START} +6 days" +%Y-%m-%d)

# Find all daily summaries for this week
DAILY_FILES=$(find "${REPO_DIR}/daily" -name "*.md" -type f | \
    while read f; do
        FILE_DATE=$(basename "$f" .md)
        if [[ "$FILE_DATE" > "$WEEK_START" || "$FILE_DATE" == "$WEEK_START" ]] && \
           [[ "$FILE_DATE" < "$WEEK_END" || "$FILE_DATE" == "$WEEK_END" ]]; then
            echo "$f"
        fi
    done | sort)

NUM_DAYS=$(echo "$DAILY_FILES" | grep -c "^" || echo "0")

echo "📅 Week ${WEEK} range: ${WEEK_START} to ${WEEK_END}"
echo "📝 Found ${NUM_DAYS} daily summaries for this week"

if [ "$NUM_DAYS" -eq 0 ]; then
    echo "⚠️  No daily summaries found for this week yet"
    exit 0
fi

# Create task file for the AI agent
TASK_FILE="/tmp/ai-news-weekly-${WEEK_ID}.txt"
cat > "$TASK_FILE" << TASK_EOF
🔍 Task: Generate Weekly AI News Summary for Week ${WEEK}, ${YEAR}

**Objective:** Aggregate and synthesize this week's daily summaries into a comprehensive weekly rollup.

**Source Material:**
Daily summaries for this week (${WEEK_START} to ${WEEK_END}):
${DAILY_FILES}

**Steps:**

1. **Read all daily summaries** from the list above

2. **Identify patterns and themes:**
   - What were the dominant trends this week?
   - Which topics appeared multiple times?
   - What were the most significant announcements?
   - Any breakthrough research papers?
   - Notable tool releases or updates?

3. **Aggregate by category:**
   - **Key Developments**: Top 3-5 themes with impact analysis
   - **Research Highlights**: Most important papers with links
   - **Tools & Frameworks**: Significant releases/updates
   - **Enterprise Adoption**: Notable deployments and case studies
   - **Statistics**: Week's key metrics and ROI data

4. **Source consolidation:**
   - Collect all unique sources from daily summaries
   - Group related sources by topic
   - Maintain all URLs and citations
   - Add weekly "Recommended Reading" section

5. **Analysis & Insights:**
   - What does this week tell us about 2026 trends?
   - How do developments connect to yearly themes?
   - What should we watch next week?

6. **Format requirements:**
   - Follow template from new-weekly.sh
   - Include links to each daily summary
   - Brief notes for each day (1 sentence)
   - Maintain source citations throughout
   - Link to previous/next weeks and yearly overview

7. **File operations:**
   - Create/update: ${FILENAME}
   - Commit: git add ${FILENAME}
   - Message: "Weekly summary: Week ${WEEK}, ${YEAR}"
   - Push: git push origin main

**Quality checks:**
- All major developments from dailies included?
- Sources properly cited?
- Analysis adds value beyond daily summaries?
- Links to daily summaries working?
- Forward/backward navigation links correct?

**Important:** This is a synthesis task. Don't just copy-paste from dailies. Identify patterns, connections, and broader implications.
TASK_EOF

echo "📋 Task description created: $TASK_FILE"
echo ""
echo "To execute manually:"
echo "  cat $TASK_FILE"
echo ""
echo "For automation, integrate with OpenClaw agent system"

# If the weekly file doesn't exist, create from template
if [ ! -f "$FILENAME" ]; then
    "${REPO_DIR}/new-weekly.sh" "$WEEK_ID"
fi

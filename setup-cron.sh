#!/bin/bash
# Setup OpenClaw cron jobs for AI News automation
# Run this script after the repository is set up

set -e

echo "🤖 Setting up OpenClaw cron jobs for AI News..."
echo ""

# Check if openclaw is available
if ! command -v openclaw &> /dev/null; then
    echo "❌ openclaw CLI not found"
    echo "   Please ensure OpenClaw is installed and in PATH"
    exit 1
fi

echo "Step 1: Creating daily AI news summary job..."
openclaw cron add \
  --name "AI News Daily Summary" \
  --cron "0 8 * * *" \
  --tz "UTC" \
  --session isolated \
  --message "Generate today's daily AI news summary for the ai-news repository.

**Task:** Research and write daily summary with comprehensive source citations

**Steps:**
1. Search web for today's agentic AI and generative AI developments
   - Query: 'agentic AI news today'
   - Query: 'generative AI research papers arxiv today'
   - Query: 'AI agent tools releases today'
   - Query: 'LLM enterprise deployment today'

2. For EACH development, gather:
   - Title and description
   - Source URL (REQUIRED - no unsourced claims)
   - Impact and significance
   - Publication date verification

3. Organize into daily template format:
   - 🔥 Key Highlights (3-5 items with [Source](URL))
   - 📚 Research Papers (new arXiv papers with links)
   - 🛠️ Tools & Frameworks (releases with GitHub/blog links)
   - 💼 Industry News (with report/announcement links)
   - 📊 Key Statistics (with [Report](URL) citations)
   - 💡 Insights & Analysis

4. **Source Citation Rules:**
   - EVERY claim needs [Source Name](https://url)
   - Prefer primary sources (arXiv, GitHub, official blogs)
   - No secondary sources when primary available
   - Include multiple sources for significant claims

5. Create file: /home/node/.openclaw/workspace/ai-news/daily/$(date +%Y-%m-%d).md

6. Git operations:
   - cd /home/node/.openclaw/workspace/ai-news
   - git add daily/$(date +%Y-%m-%d).md
   - git commit -m 'Daily update: $(date +%Y-%m-%d)'
   - git push origin main

**Quality checks:**
- All claims sourced? ✓
- URLs valid? ✓
- Content is today's news? ✓
- 8-12KB size? ✓
- Template format followed? ✓" \
  --no-deliver \
  --agent main

echo "✅ Daily summary job created"
echo ""

echo "Step 2: Creating weekly aggregation job..."
openclaw cron add \
  --name "AI News Weekly Summary" \
  --cron "0 20 * * 0" \
  --tz "UTC" \
  --session isolated \
  --message "Generate this week's AI news summary by aggregating daily summaries.

**Task:** Synthesize the week's daily summaries into comprehensive weekly rollup

**Steps:**
1. Find all daily summaries for current week (Monday-Sunday)
   - cd /home/node/.openclaw/workspace/ai-news
   - Read daily/*.md files from this week

2. Identify patterns across the week:
   - Dominant trends (appeared 2+ times)
   - Most significant research papers
   - Notable tool releases
   - Enterprise adoption patterns
   - Recurring themes

3. Aggregate by category:
   - **Key Developments**: Top 3-5 weekly themes
   - **Research Highlights**: Most important papers with links
   - **Tools & Frameworks**: Significant releases
   - **Enterprise Adoption**: Notable deployments
   - **Statistics**: Week's key metrics

4. Consolidate sources:
   - Collect unique sources from all dailies
   - Group related sources by topic
   - Maintain all URLs
   - Create 'Recommended Reading' section

5. Add analysis:
   - How do this week's developments connect to 2026 trends?
   - What patterns emerged?
   - What to watch next week?

6. Create/update: /home/node/.openclaw/workspace/ai-news/weekly/$(date +%Y-W%V).md
   - Link to each daily summary
   - Include 1-sentence notes for each day
   - Maintain source citations throughout

7. Git operations:
   - git add weekly/$(date +%Y-W%V).md
   - git commit -m 'Weekly summary: Week $(date +%V), $(date +%Y)'
   - git push origin main

**Important:** This is synthesis, not copy-paste. Identify connections and broader implications." \
  --no-deliver \
  --agent main

echo "✅ Weekly summary job created"
echo ""

echo "Step 3: Creating yearly overview update job..."
openclaw cron add \
  --name "AI News Yearly Overview Update" \
  --cron "0 21 * * 0" \
  --tz "UTC" \
  --session isolated \
  --message "Review recent developments and update yearly AI news overview if notable changes occurred.

**Task:** Conditionally update yearly overview when significant developments warrant it

**Steps:**
1. Read current yearly overview:
   - /home/node/.openclaw/workspace/ai-news/yearly/$(date +%Y).md

2. Read recent weekly summaries (last 4 weeks):
   - Find weekly/$(date +%Y)-W*.md files from past month

3. Assess if update is needed:
   **Update if ANY of these:**
   - New trend identified (appears in 2+ weekly summaries)
   - Statistics changed by >10%
   - Breakthrough paper with major impact
   - Category-defining tool release
   - Major enterprise deployment (Fortune 500)
   - Regulatory/policy announcement

   **Do NOT update for:**
   - Minor tool version bumps
   - Single isolated papers
   - Routine deployments
   - Unconfirmed reports

4. If update needed, modify sections:
   - 🔥 Major Trends: Add/update trends
   - 📚 Research Areas: Add breakthrough papers
   - 🛠️ Tools & Frameworks: Add significant tools
   - 💼 Use Cases: Add novel applications
   - 📊 Statistics: Update with latest data
   - Update 'Last Updated' date at top

5. **Source requirements:**
   - Every new claim needs [Source](URL)
   - Maintain existing source links
   - Include publication dates

6. Git operations (only if updated):
   - git add yearly/$(date +%Y).md
   - git commit -m 'Yearly update: [describe what changed]'
   - git push origin main

7. If no update needed:
   - Report: 'Yearly overview reviewed - no notable changes this week'

**Decision criteria:** Signal over noise. Quality over frequency." \
  --no-deliver \
  --agent main

echo "✅ Yearly update job created"
echo ""

echo "Step 4: Listing all AI News cron jobs..."
openclaw cron list | grep -A 3 "AI News"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Schedules:"
echo "  • Daily summary:   Every day at 8 AM UTC"
echo "  • Weekly summary:  Every Sunday at 8 PM UTC"
echo "  • Yearly update:   Every Sunday at 9 PM UTC (after weekly)"
echo ""
echo "To verify:"
echo "  openclaw cron list"
echo ""
echo "To run manually:"
echo "  openclaw cron run <job-id>"
echo ""
echo "To view history:"
echo "  openclaw cron runs --id <job-id>"

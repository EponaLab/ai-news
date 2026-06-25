#!/bin/bash
# Automated Daily AI News Research & Summary
# Uses OpenClaw agent to research and write daily summary with sources

set -e

REPO_DIR="/home/node/.openclaw/workspace/ai-news"
DATE=$(date +%Y-%m-%d)
FILENAME="${REPO_DIR}/daily/${DATE}.md"

cd "$REPO_DIR"

# Check if today's summary already exists
if [ -f "$FILENAME" ]; then
    echo "✓ Daily summary for ${DATE} already exists"
    exit 0
fi

echo "🤖 Spawning AI agent to research and generate daily summary for ${DATE}..."

# This script will be called by cron and should be run from OpenClaw context
# It expects to have access to the OpenClaw session system

# For now, create the task description that can be manually executed
cat > /tmp/daily-ai-news-task.txt << EOF
🔍 Task: Generate Daily AI News Summary for ${DATE}

**Objective:** Research and create today's daily AI news summary with comprehensive source citations.

**Steps:**

1. **Web Research** - Search for today's developments:
   - Query: "agentic AI news ${DATE}"
   - Query: "generative AI research papers ${DATE}"
   - Query: "AI agent tools releases ${DATE}"
   - Query: "LLM enterprise deployment ${DATE}"
   - Query: "arxiv AI agents ${DATE}"

2. **Source Gathering** - For each result:
   - Extract key information
   - **Record the source URL**
   - Verify publication date
   - Assess relevance and impact

3. **Content Organization:**
   - **🔥 Key Highlights**: 3-5 major developments with [Source](URL)
   - **📚 Research Papers**: New papers from arXiv with paper links
   - **🛠️ Tools & Frameworks**: Releases, updates with GitHub/blog links
   - **💼 Industry News**: Enterprise adoption, funding, partnerships with sources
   - **📊 Key Statistics**: Metrics with [Report](URL) citations
   - **💡 Insights & Analysis**: Your commentary on trends
   - **🔗 Important Links**: Must-read articles with URLs

4. **Source Citation Rules:**
   - EVERY claim needs a source
   - Format: [Source Name](https://url)
   - Include multiple sources for controversial claims
   - Link to original sources (arXiv, GitHub, company blogs, reports)
   - Avoid secondary sources when primary is available

5. **Quality Checks:**
   - Are all claims sourced?
   - Are URLs valid and direct?
   - Is the content date-appropriate (today's news)?
   - Does it fit the established format?
   - Is it 8-12KB in size?

6. **File Creation:**
   - Create: ${FILENAME}
   - Follow template format from new-daily.sh
   - Include metadata: date, week, day of year
   - Link to next day, this week, this year

7. **Commit & Push:**
   - git add daily/${DATE}.md
   - git commit -m "Daily update: ${DATE}"
   - git push origin main

**Important:** This is for the ai-news repository. Focus on agentic AI and generative AI topics. Always include source links!
EOF

echo "📋 Task description created at /tmp/daily-ai-news-task.txt"
echo ""
echo "To execute manually, run:"
echo "  cat /tmp/daily-ai-news-task.txt"
echo ""
echo "To automate via OpenClaw agent, the cron job should call a wrapper that uses sessions_spawn."

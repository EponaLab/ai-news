#!/bin/bash
# Daily AI News Summary Generator
# Runs automated web research and generates daily summary with sources

set -e

REPO_DIR="/home/node/.openclaw/workspace/ai-news"
DATE=$(date +%Y-%m-%d)
DAY_NAME=$(date +%A)
FILENAME="${REPO_DIR}/daily/${DATE}.md"

cd "$REPO_DIR"

# Check if today's summary already exists
if [ -f "$FILENAME" ]; then
    echo "✓ Daily summary for ${DATE} already exists, skipping..."
    exit 0
fi

echo "🔍 Generating daily AI news summary for ${DATE}..."

# Create a task file for the AI agent
TASK_FILE="/tmp/ai-news-daily-${DATE}.txt"
cat > "$TASK_FILE" << 'TASK_EOF'
Generate today's daily AI news summary for the ai-news repository.

Requirements:
1. Search the web for today's agentic AI and generative AI news
2. Focus on: research papers (arXiv), tool releases, enterprise deployments, industry reports
3. **ALWAYS include direct links to sources** - every claim needs a citation with URL
4. Use the daily template format from new-daily.sh
5. Organize by: Key Highlights, Research Papers, Tools, Industry News, Statistics, Analysis
6. Keep it concise but informative (aim for 8-12KB)
7. Link to relevant sources: arXiv papers, company blogs, industry reports, GitHub repos

Search queries to run:
- "agentic AI news today"
- "generative AI latest research"
- "AI agent papers arxiv [today's date]"
- "LLM tools releases [today's date]"
- "enterprise AI deployment news"

For each section:
- Provide 2-4 key items
- Include title, description, impact
- **Always add source links** in format: [Source Name](URL)

Web search and fetch content as needed to get accurate, sourced information.
Create the file at: daily/${DATE}.md
TASK_EOF

echo "Task description created: $TASK_FILE"
echo "Content:"
cat "$TASK_FILE"

# Note: This is a placeholder for OpenClaw integration
# In production, this would trigger an AI agent to do the research
echo ""
echo "⚠️  Manual step required:"
echo "    Run: openclaw --task-file $TASK_FILE"
echo "    Or integrate with OpenClaw's agent system to automate"
echo ""
echo "For now, use the template:"
"${REPO_DIR}/new-daily.sh" "$DATE"

# Commit if file was created
if [ -f "$FILENAME" ]; then
    git add "$FILENAME"
    git commit -m "Daily update: ${DATE} - Automated generation"
    git push origin main
    echo "✅ Daily summary committed and pushed"
else
    echo "⚠️  No summary file created"
fi

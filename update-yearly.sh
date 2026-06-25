#!/bin/bash
# Yearly Overview Update
# Updates the yearly overview when significant developments occur

set -e

REPO_DIR="/home/node/.openclaw/workspace/ai-news"
YEAR=$(date +%Y)
FILENAME="${REPO_DIR}/yearly/${YEAR}.md"

cd "$REPO_DIR"

echo "🔍 Checking for notable developments to update yearly overview..."

# Get recent weekly summaries (last 4 weeks)
RECENT_WEEKS=$(find "${REPO_DIR}/weekly" -name "${YEAR}-W*.md" -type f | sort -r | head -4)

echo "📅 Analyzing recent weeks for notable developments..."

# Create task file for the AI agent
TASK_FILE="/tmp/ai-news-yearly-update-${YEAR}.txt"
cat > "$TASK_FILE" << TASK_EOF
🔍 Task: Update Yearly AI News Overview for ${YEAR}

**Objective:** Review recent developments and update the yearly overview if there are notable changes to trends, statistics, or major developments.

**Current yearly overview:** ${FILENAME}

**Recent weekly summaries to review:**
${RECENT_WEEKS}

**Steps:**

1. **Read current yearly overview** to understand existing content and structure

2. **Review recent weekly summaries** (last 4 weeks) for:
   - New major trends emerging
   - Significant research breakthroughs
   - Important tool releases (major frameworks, architectures)
   - Notable enterprise deployments
   - Updated statistics or market data
   - Industry shifts or policy changes

3. **Determine if update is needed:**
   - Is there a new trend not in yearly overview?
   - Have statistics significantly changed?
   - Are there breakthrough papers that redefine the field?
   - New major players or acquisitions?
   - Regulatory or policy shifts?
   
   **If NO notable changes:** Exit without updating
   **If YES:** Proceed to update

4. **Update sections as needed:**
   - **🔥 Major Trends**: Add new trends, update existing
   - **📚 Research Areas**: Add breakthrough papers
   - **🛠️ Tools & Frameworks**: Add significant new tools
   - **💼 Use Cases**: Add novel applications
   - **📊 Statistics**: Update with latest data
   - **🎓 Academic Activity**: Add major conference results
   - **🚀 Looking Ahead**: Adjust based on new signals

5. **Maintain structure:**
   - Keep existing format and organization
   - Add new content, don't remove unless outdated
   - Update "Last Updated" date at top
   - Maintain all existing source links
   - Add new sources for new claims

6. **Source requirements:**
   - Every new claim needs a source citation
   - Format: [Source](URL)
   - Prefer primary sources (papers, official announcements)
   - Include publication dates for context

7. **Quality checks:**
   - Is the update substantive (not just minor tweaks)?
   - Are new claims properly sourced?
   - Does it maintain consistency with existing content?
   - Is the "Last Updated" date current?

8. **File operations:**
   - Update: ${FILENAME}
   - Commit with descriptive message about what changed
   - Example: "Yearly update: Added multi-modal agent trend, updated statistics"
   - Push: git push origin main

**Decision criteria for updates:**

Update if ANY of these are true:
- New trend identified (appears in 2+ weekly summaries)
- Statistics changed by >10% or new major stat available
- Breakthrough paper with >100 citations or major architectural innovation
- New category-defining tool (e.g., new agent framework standard)
- Major enterprise adoption announcement (Fortune 500 deployment)
- Regulatory/policy announcement affecting AI deployment

Do NOT update for:
- Minor tool version bumps
- Single isolated papers (wait for pattern)
- Routine enterprise deployments
- Market rumors or unconfirmed reports

**Important:** This is a living document. Update when there's signal, not noise. Quality over frequency.
TASK_EOF

echo "📋 Task description created: $TASK_FILE"
echo ""
echo "This script should be run:"
echo "  - Weekly (after weekly summary generation)"
echo "  - Or on-demand when major developments occur"
echo ""
echo "To execute manually:"
echo "  cat $TASK_FILE"

# Automation Setup for AI News

This document explains how to set up automated daily and weekly AI news summaries.

## 📋 Overview

The ai-news repository uses three automated tasks:

1. **Daily Summary** - Runs every morning, researches and generates daily news
2. **Weekly Summary** - Runs every Sunday evening, aggregates the week's dailies
3. **Yearly Update** - Runs weekly, updates yearly overview if notable developments occur

## 🤖 Automation Scripts

| Script | Purpose | Frequency | Output |
|--------|---------|-----------|--------|
| `auto-daily.sh` | Generate daily summary with web research | Daily (8 AM UTC) | `daily/YYYY-MM-DD.md` |
| `generate-weekly.sh` | Aggregate week's dailies into summary | Weekly (Sunday 8 PM UTC) | `weekly/YYYY-WXX.md` |
| `update-yearly.sh` | Update yearly overview if needed | Weekly (Sunday 9 PM UTC) | `yearly/YYYY.md` |

## 🚀 Setup Options

### Option 1: OpenClaw Cron (Recommended)

OpenClaw has a built-in cron scheduler for running agent tasks.

**Step 1: Create agent task scripts**

These scripts are already created:
- `auto-daily.sh` - Daily research and summary
- `generate-weekly.sh` - Weekly aggregation
- `update-yearly.sh` - Yearly updates

**Step 2: Schedule with OpenClaw cron**

```bash
# Daily summary - every day at 8 AM UTC
openclaw cron add "0 8 * * *" \
  --task "Generate daily AI news summary with web research and source citations" \
  --label "ai-news-daily" \
  --agent main \
  --script /home/node/.openclaw/workspace/ai-news/auto-daily.sh

# Weekly summary - every Sunday at 8 PM UTC
openclaw cron add "0 20 * * 0" \
  --task "Aggregate this week's daily summaries into weekly rollup with analysis" \
  --label "ai-news-weekly" \
  --agent main \
  --script /home/node/.openclaw/workspace/ai-news/generate-weekly.sh

# Yearly update - every Sunday at 9 PM UTC (after weekly)
openclaw cron add "0 21 * * 0" \
  --task "Review recent developments and update yearly overview if notable" \
  --label "ai-news-yearly" \
  --agent main \
  --script /home/node/.openclaw/workspace/ai-news/update-yearly.sh
```

**Step 3: Verify schedules**

```bash
openclaw cron list
```

### Option 2: System Cron (Alternative)

If OpenClaw cron is not available, use system cron:

```bash
# Edit crontab
crontab -e

# Add these lines:
0 8 * * * cd /home/node/.openclaw/workspace/ai-news && ./auto-daily.sh >> /tmp/ai-news-daily.log 2>&1
0 20 * * 0 cd /home/node/.openclaw/workspace/ai-news && ./generate-weekly.sh >> /tmp/ai-news-weekly.log 2>&1
0 21 * * 0 cd /home/node/.openclaw/workspace/ai-news && ./update-yearly.sh >> /tmp/ai-news-yearly.log 2>&1
```

### Option 3: Manual Integration

For more control, manually call the scripts when needed:

```bash
cd /home/node/.openclaw/workspace/ai-news

# Generate today's summary
./auto-daily.sh

# Generate this week's summary
./generate-weekly.sh

# Update yearly overview
./update-yearly.sh
```

## 📝 Task Details

### Daily Summary Task

**Trigger:** Every day at 8 AM UTC  
**Duration:** ~5-10 minutes  
**Actions:**
1. Search web for today's AI news (arXiv, industry reports, tool releases)
2. Extract key developments with source URLs
3. Organize into daily template format
4. Create `daily/YYYY-MM-DD.md` with comprehensive citations
5. Commit and push to GitHub

**Web Searches Performed:**
- "agentic AI news [today]"
- "generative AI research papers [today]"
- "AI agent tools releases [today]"
- "LLM enterprise deployment [today]"
- "arxiv AI agents [today]"

**Output Example:** `daily/2026-06-25.md` (8-12 KB with sources)

### Weekly Summary Task

**Trigger:** Every Sunday at 8 PM UTC  
**Duration:** ~5-8 minutes  
**Actions:**
1. Read all daily summaries from the current week
2. Identify patterns, themes, and connections
3. Aggregate key developments by category
4. Synthesize insights and analysis
5. Create `weekly/YYYY-WXX.md` with links to daily summaries
6. Commit and push to GitHub

**Analysis Includes:**
- Dominant trends of the week
- Most significant research papers
- Notable tool releases
- Enterprise adoption patterns
- What to watch next week

**Output Example:** `weekly/2026-W26.md` (5-8 KB)

### Yearly Update Task

**Trigger:** Every Sunday at 9 PM UTC (after weekly summary)  
**Duration:** ~5 minutes  
**Actions:**
1. Read recent weekly summaries (last 4 weeks)
2. Identify significant new developments
3. Determine if yearly overview needs updating
4. If notable changes: update relevant sections
5. If no notable changes: exit without update
6. Commit with descriptive message if updated

**Update Criteria:**
- New trend identified (appears in 2+ weeks)
- Statistics changed by >10%
- Breakthrough paper with major impact
- Category-defining tool release
- Major enterprise deployment announcement
- Regulatory/policy changes

**Output:** `yearly/2026.md` (updated as needed)

## 🔍 Source Citation Rules

All automated tasks follow these source citation rules:

1. **Every claim needs a source** - No unsourced statements
2. **Format:** `[Source Name](https://url)`
3. **Prefer primary sources:** arXiv papers, GitHub repos, official blogs, company announcements
4. **Include multiple sources** for significant claims
5. **Date-stamp sources** when relevant
6. **Link directly** to the specific page, not homepages

**Example citations:**
```markdown
- **DeepMind releases Gemini 2.0** with 10x faster inference ([DeepMind Blog](https://blog.deepmind.com/gemini-2))
- Research shows 88% ROI for agentic AI adopters ([Google Cloud Study 2025](https://cloud.google.com/ai-study-2025))
- **TraceCoder paper** proposes multi-agent debugging framework ([arXiv:2602.06875](https://arxiv.org/abs/2602.06875))
```

## 🛠️ Troubleshooting

### Task not running?

**Check cron status:**
```bash
openclaw cron list
openclaw cron logs ai-news-daily
```

**Check script permissions:**
```bash
ls -la /home/node/.openclaw/workspace/ai-news/*.sh
chmod +x /home/node/.openclaw/workspace/ai-news/*.sh
```

### Empty or incomplete summaries?

**Check web search access:**
- Ensure web_search tool is available
- Verify search queries are returning results
- Check rate limits on search API

**Review task logs:**
```bash
tail -f /tmp/ai-news-*.log
```

### Git push failures?

**Check git config:**
```bash
cd /home/node/.openclaw/workspace/ai-news
git config user.email
git config user.name
git remote -v
```

**Verify GitHub credentials:**
```bash
git push origin main  # Test push
```

### Sources missing?

**Review task requirements:**
- Each task file explicitly requires source citations
- Scripts check for `[Source](URL)` patterns
- Manual review needed if automated task skips sources

## 📊 Monitoring

### Daily Check
```bash
# Verify today's summary exists
ls -la /home/node/.openclaw/workspace/ai-news/daily/$(date +%Y-%m-%d).md

# Check recent commits
cd /home/node/.openclaw/workspace/ai-news && git log --oneline -5
```

### Weekly Check
```bash
# Verify this week's summary
ls -la /home/node/.openclaw/workspace/ai-news/weekly/$(date +%Y-W%V).md

# Check repository status
cd /home/node/.openclaw/workspace/ai-news && git status
```

### Monthly Check
```bash
# Count summaries generated this month
find /home/node/.openclaw/workspace/ai-news/daily -name "$(date +%Y-%m)-*.md" | wc -l

# Review yearly updates
cd /home/node/.openclaw/workspace/ai-news && git log --grep="Yearly update" --oneline
```

## 🔄 Maintenance

### Updating schedules

```bash
# Remove old schedule
openclaw cron remove ai-news-daily

# Add new schedule
openclaw cron add "0 9 * * *" --task "..." --label "ai-news-daily"
```

### Testing scripts manually

```bash
cd /home/node/.openclaw/workspace/ai-news

# Test daily generation
./auto-daily.sh

# Test weekly aggregation
./generate-weekly.sh

# Test yearly update
./update-yearly.sh
```

### Backfilling missed days

```bash
# Generate summary for specific date
DATE=2026-06-26 ./auto-daily.sh
```

## 📈 Success Metrics

**Daily summaries:**
- Published every day by 9 AM UTC
- 8-12 KB in size
- 10+ source citations per summary
- Organized by standard template

**Weekly summaries:**
- Published every Sunday by 9 PM UTC
- Synthesizes 7 daily summaries
- Identifies patterns and themes
- Links to all daily summaries

**Yearly overview:**
- Updated when notable developments occur (1-4 times per month)
- Maintains current state of the field
- Comprehensive source coverage
- Clear trend analysis

## 🚨 Important Notes

1. **Source quality matters** - Prefer peer-reviewed papers, official announcements, and reputable industry reports
2. **Date accuracy** - Ensure all content is current and date-appropriate
3. **Git hygiene** - Each task should commit only its own files with descriptive messages
4. **No duplication** - Check if summary already exists before generating
5. **Error handling** - Scripts should exit gracefully if prerequisites aren't met

## 🆘 Support

If automation fails:
1. Check task logs: `openclaw cron logs <label>`
2. Verify script permissions: `chmod +x *.sh`
3. Test manually: `./script.sh`
4. Review task files in `/tmp/ai-news-*.txt`
5. Check git status: `git status`, `git log`

---

**Repository:** https://github.com/EponaLab/ai-news  
**Scripts:** `/home/node/.openclaw/workspace/ai-news/`  
**Documentation:** This file (`CRON.md`)

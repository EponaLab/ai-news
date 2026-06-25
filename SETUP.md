# Setup Instructions

## 📋 Prerequisites

1. GitHub account with access to the **EponaLab** organization
2. GitHub CLI (`gh`) or GitHub Personal Access Token with `repo` scope
3. Git installed locally

## 🚀 Quick Setup

### Option 1: Using GitHub CLI (Recommended)

```bash
cd /home/node/.openclaw/workspace/ai-news

# Authenticate with GitHub (if not already done)
gh auth login

# Create the repository in EponaLab org
gh repo create EponaLab/ai-news \
  --public \
  --description "Daily, weekly, and yearly summaries of agentic and generative AI news, research papers, tools, and use cases" \
  --source=. \
  --remote=origin \
  --push
```

### Option 2: Manual Setup

1. **Create repository on GitHub:**
   - Go to https://github.com/organizations/EponaLab/repositories/new
   - Repository name: `ai-news`
   - Description: `Daily, weekly, and yearly summaries of agentic and generative AI news, research papers, tools, and use cases`
   - Visibility: Public
   - **Do NOT** initialize with README (we already have one)
   - Click "Create repository"

2. **Push local repository:**
   ```bash
   cd /home/node/.openclaw/workspace/ai-news
   ./push.sh
   ```

   Or manually:
   ```bash
   cd /home/node/.openclaw/workspace/ai-news
   git remote add origin https://github.com/EponaLab/ai-news.git
   git branch -M main
   git push -u origin main
   ```

## 📁 Repository Structure

```
ai-news/
├── README.md           # Repository overview and navigation
├── daily/              # Daily news summaries
│   └── 2026-06-25.md   # Today's comprehensive analysis
├── weekly/             # Weekly rollup summaries
│   └── 2026-W26.md     # This week (June 22-28)
├── yearly/             # Yearly overviews and trends
│   └── 2026.md         # 2026 comprehensive overview
├── .gitignore          # Git ignore patterns
├── push.sh             # Helper script for pushing to GitHub
└── SETUP.md            # This file
```

## ✅ Verification

After pushing, verify the repository is live:

```bash
# Using GitHub CLI
gh repo view EponaLab/ai-news --web

# Or visit directly
open https://github.com/EponaLab/ai-news
```

## 📝 Daily Update Workflow

To add new daily summaries:

```bash
cd /home/node/.openclaw/workspace/ai-news

# Create new daily file (template)
cat > daily/$(date +%Y-%m-%d).md << 'EOF'
# Daily Summary: $(date +"%B %d, %Y (%A)")

**Date:** $(date +"%A, %B %d, %Y")  
**Week:** $(date +%V) of $(date +%Y)  
**Day:** $(date +%j) of 365

---

## 🔥 Key Highlights

(Add content here)

---

## 📊 Key Statistics

(Add stats here)

---

**Next:** [Daily Summary for $(date -d tomorrow +%Y-%m-%d)](./$(date -d tomorrow +%Y-%m-%d).md)  
**This Week:** [Week $(date +%V) Summary](../weekly/$(date +%Y-W%V).md)  
**This Year:** [$(date +%Y) Annual Overview](../yearly/$(date +%Y).md)
EOF

# Edit the file
# (Add your content)

# Commit and push
git add daily/$(date +%Y-%m-%d).md
git commit -m "Daily update: $(date +%Y-%m-%d)"
git push
```

## 🔄 Weekly Update Workflow

At the end of each week (Sunday), consolidate the week:

```bash
cd /home/node/.openclaw/workspace/ai-news

# Update weekly summary
# Edit weekly/2026-WXX.md with the week's developments

git add weekly/2026-W$(date +%V).md
git commit -m "Weekly summary: Week $(date +%V), $(date +%Y)"
git push
```

## 📅 Automation Ideas

Consider setting up:

1. **Daily cron job** to create daily template files
2. **Weekly cron job** to generate weekly summaries
3. **GitHub Actions** for automated publishing
4. **RSS feed** generation from markdown files

## 🛠️ Troubleshooting

### Authentication Issues

If you get authentication errors:

```bash
# Generate a GitHub Personal Access Token
# https://github.com/settings/tokens/new
# Scopes needed: repo, workflow

# Configure git to use the token
git remote set-url origin https://YOUR_TOKEN@github.com/EponaLab/ai-news.git
```

### Permission Issues

If you can't create repositories in EponaLab:
- Verify you have owner/admin permissions in the organization
- Ask an org admin to grant you repository creation permissions

### Push Failures

```bash
# If push fails, try:
git pull origin main --rebase
git push origin main
```

## 📧 Support

For issues or questions, contact the EponaLab team or create an issue in the repository once it's live.

---

**Repository:** https://github.com/EponaLab/ai-news  
**Organization:** https://github.com/EponaLab

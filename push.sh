#!/bin/bash
# Push script for ai-news repository
# Run this after creating the repository on GitHub

# Repository details
ORG="EponaLab"
REPO="ai-news"
REMOTE_URL="https://github.com/${ORG}/${REPO}.git"

echo "🚀 Setting up remote and pushing ai-news repository..."
echo ""
echo "Repository: ${REMOTE_URL}"
echo ""

# Add remote if not already added
if git remote | grep -q "origin"; then
    echo "✓ Remote 'origin' already exists"
    git remote set-url origin ${REMOTE_URL}
else
    echo "→ Adding remote 'origin'"
    git remote add origin ${REMOTE_URL}
fi

# Rename branch to main if it's master
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "master" ]; then
    echo "→ Renaming branch from master to main"
    git branch -M main
fi

# Push to GitHub
echo "→ Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Done! Repository should now be live at:"
echo "   https://github.com/${ORG}/${REPO}"

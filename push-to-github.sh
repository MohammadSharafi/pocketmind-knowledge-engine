#!/bin/bash

# Script to push PocketMind LocalAI to GitHub
# Make sure you've created the repository at: https://github.com/MohammadSh1379/pocketmind-localai

GITHUB_USER="MohammadSh1379"
REPO_NAME="pocketmind-localai"

echo "Setting up GitHub remote for $GITHUB_USER/$REPO_NAME..."

# Add remote (will update if it already exists)
git remote remove origin 2>/dev/null
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

# Ensure we're on main branch
git branch -M main

echo ""
echo "Ready to push! Make sure you've created the repository at:"
echo "https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
read -p "Press Enter to push to GitHub (or Ctrl+C to cancel)..."

# Push to GitHub
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo "View your repo at: https://github.com/$GITHUB_USER/$REPO_NAME"
else
    echo ""
    echo "❌ Push failed. Make sure:"
    echo "1. The repository exists at https://github.com/$GITHUB_USER/$REPO_NAME"
    echo "2. You have push access"
    echo "3. You're authenticated (git credential helper or SSH key)"
fi


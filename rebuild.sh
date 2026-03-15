#!/usr/bin/env bash

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 NixOS Configuration Sync Started${NC}"

# Navigate to nixos directory
# Using /etc/nixos as requested, but falling back to script location if needed
CONFIG_DIR="/etc/nixos"
if [ ! -d "$CONFIG_DIR" ]; then
    CONFIG_DIR="/home/eric/nixos"
fi

echo -e "${BLUE}📂 Targeting: $CONFIG_DIR${NC}"
cd "$CONFIG_DIR" || { echo -e "${RED}❌ Error: Could not enter directory $CONFIG_DIR${NC}"; exit 1; }

# Add all changes to git
echo -e "${BLUE}➕ Staging changes...${NC}"
git add .

# Check if there are any changes staged
if git diff --cached --quiet; then
    echo -e "${YELLOW}ℹ️ No changes to commit.${NC}"
    # Still run switch just in case the user wants to re-apply
    echo -e "${BLUE}🔄 Running switch anyway...${NC}"
    nh os switch .
    exit 0
fi

# AI-like detection logic
echo -e "${BLUE}🔍 Analyzing changes...${NC}"

# 1. Check if broken (Evaluation test)
echo -n "   Checking evaluation... "
if ! nix flake check --no-build &>/dev/null; then
    TYPE="broken"
    echo -e "${RED}FAILED${NC}"
else
    echo -e "${GREEN}PASSED${NC}"
    
    # 2. Check if it's an update (only flake.lock)
    CHANGED_FILES=$(git diff --cached --name-only)
    FILE_COUNT=$(echo "$CHANGED_FILES" | wc -l)
    
    if [[ "$CHANGED_FILES" == "flake.lock" ]]; then
        TYPE="update"
    else
        # 3. Default to fix
        TYPE="fix"
    fi
fi

# Get change stats for a descriptive commit message
STATS=$(git diff --cached --stat | tail -n 1 | sed 's/^[ ]*//')
COMMIT_MSG="[$TYPE] $STATS"

echo -e "${BLUE}📝 Committing as: ${YELLOW}$COMMIT_MSG${NC}"
git commit -m "$COMMIT_MSG"

# Execute system switch
echo -e "${BLUE}⚙️ Applying system configuration...${NC}"
nh os switch .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ System successfully updated and switched!${NC}"
else
    echo -e "${RED}❌ System switch failed. Check logs above.${NC}"
    exit 1
fi

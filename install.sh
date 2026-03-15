#!/bin/bash

# Configuration
# Replace this with your actual repository URL
REPO_URL="https://github.com/anthuanvasquez/skills.git"
TEMP_DIR="/tmp/skills-temp-$(date +%s)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== AI Project Bootstrapper ===${NC}"

# 1. Project Name
read -p "Enter project name (will create directory): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo "Project name cannot be empty."
    exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
    echo "Directory $PROJECT_NAME already exists."
    read -p "Do you want to continue and potentially overwrite files? (y/n) " OVERWRITE
    if [[ "$OVERWRITE" != "y" ]]; then
        exit 1
    fi
else
    mkdir -p "$PROJECT_NAME"
fi

# 2. Tool Selection
echo -e "\nWhich tools do you want to configure?"
echo "1) GitHub Copilot (.github)"
echo "2) Claude Code (.claude)"
echo "3) Google Antigravity (.agent)"
echo "4) All of the above"
read -p "Select options (1-4): " OPTION

# 3. Clone Repository (Simulating fetching latest rules)
echo -e "\n${BLUE}Fetching configuration files...${NC}"
# Check if we are running locally in the repo for testing, otherwise clone
if [ -d ".agent" ] && [ -d ".github" ] && [ -d ".claude" ]; then
  # Local usage (dev mode)
  SOURCE_DIR="."
  echo "Using local source files."
else
  # Remote usage (curl mode)
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
      echo "Error cloning repository. Please check REPO_URL in script."
      exit 1
  fi
  SOURCE_DIR="$TEMP_DIR"
fi

# 4. Copy Files
echo -e "\n${GREEN}Setting up $PROJECT_NAME...${NC}"

install_copilot() {
    echo "  -> Configure Copilot..."
    mkdir -p "$PROJECT_NAME/.github"
    cp -r "$SOURCE_DIR/.github/"* "$PROJECT_NAME/.github/" 2>/dev/null
}

install_claude() {
    echo "  -> Configure Claude..."
    mkdir -p "$PROJECT_NAME/.claude"
    cp -r "$SOURCE_DIR/.claude/"* "$PROJECT_NAME/.claude/" 2>/dev/null
}

install_antigravity() {
    echo "  -> Configure Antigravity..."
    mkdir -p "$PROJECT_NAME/.agent"
    cp -r "$SOURCE_DIR/.agent/"* "$PROJECT_NAME/.agent/" 2>/dev/null
}

case $OPTION in
    1) install_copilot ;;
    2) install_claude ;;
    3) install_antigravity ;;
    4)
       install_copilot
       install_claude
       install_antigravity
       ;;
    *) echo "Invalid option";;
esac

# 5. Cleanup
if [ "$SOURCE_DIR" == "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo -e "\n${GREEN}✅ Project $PROJECT_NAME ready!${NC}"
echo "Location: $(pwd)/$PROJECT_NAME"

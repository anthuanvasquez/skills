#!/bin/bash

REPO_URL="https://github.com/anthuanvasquez/skills.git"
TEMP_DIR="/tmp/skills-temp-$(date +%s)"
GLOBAL_SKILLS_DIR="$HOME/.agents/skills"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== AI Skills Global Bootstrapper ===${NC}"

echo -e "\n${BLUE}Fetching configuration files...${NC}"

if [ -d "skills" ] && [ -d "workflows" ]; then
  SOURCE_DIR="$(pwd)"
  echo "Using local source files."
else
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1
  
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error cloning repository. Please check REPO_URL in script.${NC}"
    exit 1
  fi
  SOURCE_DIR="$TEMP_DIR"
fi

echo -e "\n${BLUE}Installing skills globally to ${GLOBAL_SKILLS_DIR}...${NC}"

mkdir -p "$HOME/.agents"

if [ -d "$GLOBAL_SKILLS_DIR" ]; then
  rm -rf "$GLOBAL_SKILLS_DIR"
fi

cp -r "$SOURCE_DIR/skills" "$GLOBAL_SKILLS_DIR"
echo -e "${GREEN}Global skills installed!${NC}"

echo -e "\n${BLUE}Which AI platforms do you want to configure? (Space-separated, e.g. '1 2', or '4' for all)${NC}"
echo "1) Google Gemini CLI"
echo "2) Google Antigravity"
echo "3) OpenCode"
echo "4) All of the above"
read -p "Select options: " OPTIONS

setup_platform() {
  local PLATFORM_NAME=$1
  local TARGET_DIR=$2
  local SKILLS_LINK=$3
  local AGENTS_FILE=$4
    
  echo "  -> Configuring $PLATFORM_NAME..."
  mkdir -p "$TARGET_DIR"
    
  if [ -L "$SKILLS_LINK" ] || [ -d "$SKILLS_LINK" ]; then
    rm -rf "$SKILLS_LINK"
  fi
  ln -s "$GLOBAL_SKILLS_DIR" "$SKILLS_LINK"
    
  if [ -f "$SOURCE_DIR/GEMINI.md" ]; then
    cp "$SOURCE_DIR/GEMINI.md" "$AGENTS_FILE"
  fi
}

for OPT in $OPTIONS; do
  case $OPT in
    1) 
      setup_platform "Google Gemini CLI" "$HOME/.gemini" "$HOME/.gemini/skills" "$HOME/.gemini/GEMINI.md"
      ;;
    2) 
      setup_platform "Google Antigravity" "$HOME/.gemini/antigravity" "$HOME/.gemini/antigravity/skills" "$HOME/.gemini/AGENTS.md"
      ;;
    3) 
      setup_platform "OpenCode" "$HOME/.config/opencode" "$HOME/.config/opencode/skills" "$HOME/.config/opencode/AGENTS.md"
      ;;
    4)
      setup_platform "Google Gemini CLI" "$HOME/.gemini" "$HOME/.gemini/skills" "$HOME/.gemini/GEMINI.md"
      setup_platform "Google Antigravity" "$HOME/.gemini/antigravity" "$HOME/.gemini/antigravity/skills" "$HOME/.gemini/AGENTS.md"
      setup_platform "OpenCode" "$HOME/.config/opencode" "$HOME/.config/opencode/skills" "$HOME/.config/opencode/AGENTS.md"
      break
      ;;
  esac
done

if [ "$SOURCE_DIR" == "$TEMP_DIR" ]; then
  rm -rf "$TEMP_DIR"
fi

echo -e "\n${GREEN}✅ Installation complete!${NC}"


#!/bin/bash

# Configuration
REPO_URL="https://github.com/anthuanvasquez/skills.git"
TEMP_DIR="/tmp/skills-temp-$(date +%s)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== AI Project Bootstrapper ===${NC}"

# 1. Project Name
read -p "Enter project name (will create directory or use existing if '.'): " PROJECT_NAME
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name cannot be empty.${NC}"
    exit 1
fi

if [ "$PROJECT_NAME" != "." ]; then
    if [ -d "$PROJECT_NAME" ]; then
        echo -e "${YELLOW}Directory $PROJECT_NAME already exists.${NC}"
        read -p "Do you want to continue and potentially overwrite files? (y/n) " OVERWRITE
        if [[ "$OVERWRITE" != "y" ]]; then
            exit 1
        fi
    else
        mkdir -p "$PROJECT_NAME"
    fi
fi

# 2. Tool Selection
echo -e "\n${BLUE}Which AI agents do you want to configure?${NC}"
echo "1) Google Antigravity (.agent)"
echo "2) Google Gemini CLI (.gemini)"
echo "3) Both"
read -p "Select option (1-3): " OPTION

# 3. Clone Repository
echo -e "\n${BLUE}Fetching configuration files...${NC}"
if [ -d "skills" ] && [ -d "workflows" ]; then
  # Local usage (dev mode)
  SOURCE_DIR="."
  echo "Using local source files."
else
  # Remote usage (curl mode)
  git clone --depth 1 "$REPO_URL" "$TEMP_DIR" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
      echo -e "${RED}Error cloning repository. Please check REPO_URL in script.${NC}"
      exit 1
  fi
  SOURCE_DIR="$TEMP_DIR"
fi

# 4. Copy Files
echo -e "\n${GREEN}Setting up $PROJECT_NAME...${NC}"

install_antigravity() {
    echo "  -> Configuring Google Antigravity..."
    mkdir -p "$PROJECT_NAME/.agent"
    
    if [ -d "$SOURCE_DIR/skills" ]; then
        cp -r "$SOURCE_DIR/skills" "$PROJECT_NAME/.agent/"
    fi
    if [ -d "$SOURCE_DIR/workflows" ]; then
        cp -r "$SOURCE_DIR/workflows" "$PROJECT_NAME/.agent/"
    fi
}

install_gemini() {
    echo "  -> Configuring Google Gemini CLI..."
    mkdir -p "$PROJECT_NAME/.gemini"
    
    if [ -d "$SOURCE_DIR/skills" ]; then
        cp -r "$SOURCE_DIR/skills" "$PROJECT_NAME/.gemini/"
    fi
    if [ -d "$SOURCE_DIR/workflows" ]; then
        cp -r "$SOURCE_DIR/workflows" "$PROJECT_NAME/.gemini/"
    fi
    if [ -f "$SOURCE_DIR/GEMINI.md" ]; then
        cp "$SOURCE_DIR/GEMINI.md" "$PROJECT_NAME/.gemini/"
    fi
}

case $OPTION in
    1) install_antigravity ;;
    2) install_gemini ;;
    3)
       install_antigravity
       install_gemini
       ;;
    *) 
       echo -e "${RED}Invalid option${NC}"
       if [ "$SOURCE_DIR" == "$TEMP_DIR" ]; then rm -rf "$TEMP_DIR"; fi
       exit 1
       ;;
esac

# 5. Cleanup
if [ "$SOURCE_DIR" == "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo -e "\n${GREEN}✅ Project $PROJECT_NAME ready!${NC}"
if [ "$PROJECT_NAME" == "." ]; then
    echo "Location: $(pwd)"
else
    echo "Location: $(pwd)/$PROJECT_NAME"
fi

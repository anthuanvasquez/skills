#!/bin/bash

# Run checks
ERRORS=0

check_exists() {
    if [ ! -e "$1" ]; then
        echo "❌ Missing: $1"
        ERRORS=$((ERRORS+1))
    else
        echo "✅ Found: $1"
    fi
}

echo -e "\n--- Validating Google Gemini CLI ---"
check_exists "$HOME/.gemini/skills"
check_exists "$HOME/.gemini/AGENTS.md"
check_exists "$HOME/.gemini/commands"

echo -e "\n--- Validating Google Antigravity ---"
check_exists "$HOME/.gemini/antigravity/skills"
if [ -e "$HOME/.gemini/antigravity/AGENTS.md" ]; then
    echo "❌ Error: AGENTS.md should NOT exist in Antigravity folder"
    ERRORS=$((ERRORS+1))
else
    echo "✅ Verified: No AGENTS.md in Antigravity folder"
fi

echo -e "\n--- Validating OpenCode ---"
check_exists "$HOME/.config/opencode/skills"
check_exists "$HOME/.config/opencode/AGENTS.md"

if [ $ERRORS -eq 0 ]; then
    echo -e "\n🎉 All tests passed successfully!"
    exit 0
else
    echo -e "\n💥 $ERRORS tests failed."
    exit 1
fi


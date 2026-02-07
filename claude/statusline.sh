#!/bin/bash
# Claude Code status line

input=$(cat)

DIR=$(echo "$input" | jq -r '.workspace.current_dir')
MODEL=$(echo "$input" | jq -r '.model.display_name')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
AGENT=$(echo "$input" | jq -r '.agent.name // empty')

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
RESET='\033[0m'

# Color-coded context percentage
if [ "$PCT" -ge 90 ]; then CTX_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then CTX_COLOR="$YELLOW"
else CTX_COLOR="$GREEN"; fi

# Git info with caching (5s TTL)
CACHE_FILE="/tmp/claude-statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
    [ ! -f "$CACHE_FILE" ] || \
    [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

if cache_is_stale; then
    if git -C "$DIR" rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)
        DIRTY=$(git -C "$DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        echo "$BRANCH|$DIRTY" > "$CACHE_FILE"
    else
        echo "|" > "$CACHE_FILE"
    fi
fi

IFS='|' read -r BRANCH DIRTY < "$CACHE_FILE"

GIT_INFO=""
if [ -n "$BRANCH" ]; then
    if [ "$DIRTY" -gt 0 ]; then
        GIT_INFO=" ($BRANCH *)"
    else
        GIT_INFO=" ($BRANCH)"
    fi
fi

AGENT_INFO=""
if [ -n "$AGENT" ]; then
    AGENT_INFO=" ${CYAN}[agent: $AGENT]${RESET}"
fi

printf '%b' "$(basename "$DIR")$GIT_INFO [$MODEL] ${CTX_COLOR}[ctx: ${PCT}%]${RESET}$AGENT_INFO\n"

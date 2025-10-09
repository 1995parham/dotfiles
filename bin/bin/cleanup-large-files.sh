#!/usr/bin/env bash

# https://stackoverflow.com/questions/3822621/how-to-exit-if-a-command-failed
set -eu
set -o pipefail

# cleanup-large-files.sh
# Script to remove files larger than 5MB from git history and report them

# Configuration
SIZE_THRESHOLD="1M"
# Parse and convert to bytes
SIZE_BYTES=$(echo "$SIZE_THRESHOLD" | awk '
    /[0-9]+K$/ {printf "%.0f", substr($0, 1, length($0)-1) * 1024; exit}
    /[0-9]+M$/ {printf "%.0f", substr($0, 1, length($0)-1) * 1048576; exit}
    /[0-9]+G$/ {printf "%.0f", substr($0, 1, length($0)-1) * 1073741824; exit}
    {print $0}
')

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Git Large Files Cleanup Script ===${NC}\n"

# Check if git-filter-repo is installed
if ! command -v git-filter-repo &>/dev/null; then
    echo -e "${RED}Error: git-filter-repo is not installed${NC}"
    echo "Install it with: brew install git-filter-repo"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Get repository size before cleanup
echo -e "${GREEN}Analyzing repository...${NC}"
SIZE_BEFORE=$(git count-objects -vH | grep "size-pack" | awk '{print $2, $3}')
echo "Repository size before: $SIZE_BEFORE"

# Create a temporary directory for analysis
TEMP_DIR=$(mktemp -d)
ANALYSIS_FILE="$TEMP_DIR/files-to-remove.txt"

echo -e "\n${GREEN}Finding files larger than ${SIZE_THRESHOLD}...${NC}"

# Find all large files in history
git rev-list --objects --all |
    git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
    awk -v threshold="$SIZE_BYTES" '/^blob/ {if($3 > threshold) print $3, $4}' |
    sort -rn >"$ANALYSIS_FILE"

# Count files found
FILE_COUNT=$(wc -l <"$ANALYSIS_FILE" | tr -d ' ')

if [ "$FILE_COUNT" -eq 0 ]; then
    echo -e "${GREEN}No files larger than ${SIZE_THRESHOLD} found!${NC}"
    rm -rf "$TEMP_DIR"
    exit 0
fi

echo -e "${YELLOW}Found $FILE_COUNT file(s) to remove${NC}\n"

# Show files that will be removed
echo "Files to be removed:"
echo "-------------------"
while read -r size path; do
    size_mb=$(echo "scale=1; $size / 1048576" | bc)
    echo "  [${size_mb} MB] $path"
done <"$ANALYSIS_FILE"

# Ask for confirmation
echo -e "\n${YELLOW}Warning: This will rewrite git history!${NC}"
read -p "Do you want to continue? (yes/no): " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Cleanup cancelled."
    rm -rf "$TEMP_DIR"
    exit 0
fi

# Backup remote configuration
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

# Run git-filter-repo
echo -e "\n${GREEN}Removing large files from history...${NC}"
git filter-repo --strip-blobs-bigger-than "$SIZE_THRESHOLD" --force

# Restore remote if it existed
if [ -n "$REMOTE_URL" ]; then
    git remote add origin "$REMOTE_URL"
fi

# Get repository size after cleanup
SIZE_AFTER=$(git count-objects -vH | grep "size-pack" | awk '{print $2, $3}')

# Generate report
echo -e "\n${GREEN}=== Cleanup Report ===${NC}\n"

# Check if filter-repo created analysis files
if [ -d "filter-repo/analysis" ] && [ -f "filter-repo/analysis/path-deleted-sizes.txt" ]; then
    echo "Files Removed from Git History:"
    echo ""
    printf "%-15s %-10s %s\n" "Size (bytes)" "Size (MB)" "File Path"
    printf "%-15s %-10s %s\n" "---------------" "----------" "---------"

    awk -v threshold="$SIZE_BYTES" '$1 > threshold {
        size_mb = sprintf("%.1f", $1 / 1048576)
        printf "%-15s %-10s %s\n", $1, size_mb " MB", $4
    }' filter-repo/analysis/path-deleted-sizes.txt | sort -rn

    TOTAL_FILES=$(awk -v threshold="$SIZE_BYTES" '$1 > threshold' filter-repo/analysis/path-deleted-sizes.txt | wc -l | tr -d ' ')
    echo ""
    echo "Total: $TOTAL_FILES unique file(s) removed"
else
    echo "Detailed analysis not available."
    echo "Files were removed based on size threshold: $SIZE_THRESHOLD"
fi

echo ""
echo "Repository size:"
echo "  Before: $SIZE_BEFORE"
echo "  After:  $SIZE_AFTER"

# Calculate savings if possible
SIZE_BEFORE_NUM=$(echo "$SIZE_BEFORE" | awk '{print $1}')
SIZE_AFTER_NUM=$(echo "$SIZE_AFTER" | awk '{print $1}')
UNIT=$(echo "$SIZE_BEFORE" | awk '{print $2}')

if [ "$UNIT" = "$UNIT" ]; then
    SAVINGS=$(echo "$SIZE_BEFORE_NUM - $SIZE_AFTER_NUM" | bc)
    if (($(echo "$SAVINGS > 0" | bc -l))); then
        PERCENT=$(echo "scale=1; ($SAVINGS / $SIZE_BEFORE_NUM) * 100" | bc)
        echo "  Savings: ${SAVINGS} ${UNIT} (${PERCENT}% reduction)"
    fi
fi

echo -e "\n${YELLOW}Important Next Steps:${NC}"
echo "1. Verify the cleanup was successful"
echo "2. If you need to push changes, use: git push --force"
echo "3. All collaborators will need to re-clone the repository"
echo "4. Consider creating backups of removed files if needed"

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "\n${GREEN}Cleanup complete!${NC}"

#!/bin/bash

set -eo pipefail

# Push local git repositories to GitHub organization/user account.
# Can operate on a single repo or traverse a directory of repos.

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] [DIRECTORY...]

Push local git repositories to GitHub using gh CLI.

OPTIONS:
    -o, --org NAME       GitHub organization or username (required)
    -x, --prefix PREFIX  Add prefix to repository names (e.g., "work-" creates "work-reponame")
    -a, --reauthor       Run 'git reauthor' to rewrite commits before pushing
    -p, --public         Create public repositories (default: private)
    -r, --recursive      Traverse directories and push all git repos found
    -d, --dry-run        Show what would be done without making changes
    -f, --force          Skip confirmation prompts
    -h, --help           Show this help message

ARGUMENTS:
    DIRECTORY            One or more directories to process (default: current directory)

EXAMPLES:
    # Push current directory to organization
    $(basename "$0") -o myorg

    # Push all repos in a directory to organization
    $(basename "$0") -o myorg -r ~/projects/

    # Push specific directories as public repos
    $(basename "$0") -o myorg -p ./repo1 ./repo2

    # Push with a prefix (creates "work-reponame" instead of "reponame")
    $(basename "$0") -o myorg -x "work-" ./myrepo

    # Reauthor commits before pushing
    $(basename "$0") -o myorg -a ./myrepo

    # Dry run to see what would happen
    $(basename "$0") -o myorg -r -d ~/projects/
EOF
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Default values
ORG_NAME=""
PREFIX=""
REAUTHOR=false
VISIBILITY="private"
RECURSIVE=false
DRY_RUN=false
FORCE=false
DIRECTORIES=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    -o | --org)
        ORG_NAME="$2"
        shift 2
        ;;
    -x | --prefix)
        PREFIX="$2"
        shift 2
        ;;
    -a | --reauthor)
        REAUTHOR=true
        shift
        ;;
    -p | --public)
        VISIBILITY="public"
        shift
        ;;
    -r | --recursive)
        RECURSIVE=true
        shift
        ;;
    -d | --dry-run)
        DRY_RUN=true
        shift
        ;;
    -f | --force)
        FORCE=true
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    -*)
        log_error "Unknown option: $1"
        usage
        exit 1
        ;;
    *)
        DIRECTORIES+=("$1")
        shift
        ;;
    esac
done

# Validate required arguments
if [[ -z "$ORG_NAME" ]]; then
    log_error "Organization name is required (-o/--org)"
    usage
    exit 1
fi

# Check gh is installed and authenticated
if ! command -v gh &>/dev/null; then
    log_error "gh CLI is not installed. Install it from https://cli.github.com/"
    exit 1
fi

if ! gh auth status &>/dev/null; then
    log_error "Not authenticated with gh. Run 'gh auth login' first."
    exit 1
fi

# Default to current directory if none specified
if [[ ${#DIRECTORIES[@]} -eq 0 ]]; then
    DIRECTORIES=(".")
fi

push_repo() {
    local dir="$1"
    local repo_name
    repo_name="${PREFIX}$(basename "$(cd "$dir" && pwd)")"

    log_info "Processing: $repo_name"

    if [[ ! -d "$dir/.git" ]]; then
        log_warn "Skipping '$repo_name': not a git repository"
        return 0
    fi

    cd "$dir"

    # Reauthor commits if requested
    if [[ "$REAUTHOR" == true ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY-RUN] Would run 'git reauthor' to rewrite commits"
        else
            log_info "Rewriting commits with 'git reauthor'..."
            if ! git reauthor; then
                log_error "Failed to reauthor commits in $repo_name"
                return 1
            fi
        fi
    fi

    # Check if repo already exists on GitHub
    if gh repo view "$ORG_NAME/$repo_name" &>/dev/null; then
        log_warn "Repository '$ORG_NAME/$repo_name' already exists on GitHub"

        if [[ "$FORCE" != true && "$DRY_RUN" != true ]]; then
            read -rp "Update remote origin and push anyway? [y/N] " confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                log_info "Skipping $repo_name"
                return 0
            fi
        fi

        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY-RUN] Would update origin and push to existing repo"
            return 0
        fi

        # Update origin and push
        if git remote get-url origin &>/dev/null; then
            git remote remove origin
        fi
        git remote add origin "https://github.com/$ORG_NAME/$repo_name.git"
        git push -u origin --all
        git push origin --tags

        # Disable actions if requested
        if [[ "$NO_ACTIONS" == true ]]; then
            log_info "Disabling GitHub Actions..."
            gh repo edit "$ORG_NAME/$repo_name" --enable-actions=false
        fi

        log_success "Pushed to existing repository: https://github.com/$ORG_NAME/$repo_name"
    else
        if [[ "$DRY_RUN" == true ]]; then
            log_info "[DRY-RUN] Would create $VISIBILITY repo '$ORG_NAME/$repo_name' and push"
            return 0
        fi

        # Remove existing origin if present
        if git remote get-url origin &>/dev/null; then
            log_info "Removing existing origin remote..."
            git remote remove origin
        fi

        # Create and push
        gh repo create "$ORG_NAME/$repo_name" "--$VISIBILITY" --source=. --push

        log_success "Created and pushed: https://github.com/$ORG_NAME/$repo_name"
    fi
}

process_directory() {
    local base_dir="$1"

    if [[ ! -d "$base_dir" ]]; then
        log_error "Directory not found: $base_dir"
        return 1
    fi

    base_dir=$(cd "$base_dir" && pwd)

    if [[ "$RECURSIVE" == true ]]; then
        # Find all directories containing .git
        while IFS= read -r -d '' git_dir; do
            repo_dir=$(dirname "$git_dir")
            push_repo "$repo_dir"
            echo ""
        done < <(find "$base_dir" -maxdepth 2 -name ".git" -type d -print0 2>/dev/null)
    else
        push_repo "$base_dir"
    fi
}

# Main execution
log_info "Target organization: $ORG_NAME"
[[ -n "$PREFIX" ]] && log_info "Repository prefix: $PREFIX"
[[ "$REAUTHOR" == true ]] && log_info "Reauthor: enabled"
log_info "Visibility: $VISIBILITY"
[[ "$DRY_RUN" == true ]] && log_warn "DRY RUN MODE - No changes will be made"
echo ""

for dir in "${DIRECTORIES[@]}"; do
    process_directory "$dir"
done

log_success "Done!"

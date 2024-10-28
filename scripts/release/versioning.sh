#!/bin/bash
set -e

SERVICE_NAME=$1
if [[ -z "$SERVICE_NAME" ]]; then
  echo "Error: Service name required (e.g., auth-service)"
  exit 1
fi

RELEASE_TYPE=${RELEASE_TYPE:-"patch"}
DEFAULT_BRANCH="main"
REMOTE=${REMOTE:-"origin"}
REPO_URL="https://github.com/itsferdiardiansa/ERP-Api"
PR_URL="https://github.com/itsferdiardiansa/ERP-Api/pull"
COMPARE_URL="$REPO_URL/compare"

# Fetch the latest tags and determine the latest tag for the service
git fetch --tags "$REMOTE"
LATEST_TAG=$(git tag --list "${SERVICE_NAME}-v*" --sort=-v:refname | head -n 1)

# Determine the version to use based on the latest tag or initialize
if [[ -z "$LATEST_TAG" ]]; then
  MAJOR=0; MINOR=0; PATCH=1
  NEW_TAG="${SERVICE_NAME}-v$MAJOR.$MINOR.$PATCH"
  INITIAL_COMMIT_RANGE="HEAD"
else
  VERSION_NUM="${LATEST_TAG//[!0-9.]/}"
  IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_NUM"
  
  case "$RELEASE_TYPE" in
    major) ((MAJOR+=1)); MINOR=0; PATCH=0 ;;
    minor) ((MINOR+=1)); PATCH=0 ;;
    patch) ((PATCH+=1)) ;;
  esac
  
  NEW_TAG="${SERVICE_NAME}-v$MAJOR.$MINOR.$PATCH"
  INITIAL_COMMIT_RANGE="${LATEST_TAG}..HEAD"
fi

# Check if we are on the default branch and pull the latest changes
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
  git checkout "$DEFAULT_BRANCH"
  git pull "$REMOTE" "$DEFAULT_BRANCH"
fi

# Initialize release notes with links and title
RELEASE_NOTES="[Pull Requests]($PR_URL) | [Compare]($COMPARE_URL/$LATEST_TAG...$NEW_TAG)"

RELEASE_NOTES+="

## What's Changed
"

# Define the commit categories
CATEGORIES=("feat" "fix" "docs" "style" "refactor" "perf" "test" "chore" "ci")

# Collect commits for each category using grep to match commitlint patterns
for CATEGORY in "${CATEGORIES[@]}"; do
  UPPER_CATEGORY=$(echo "$CATEGORY" | tr '[:lower:]' '[:upper:]')
  
  if [[ "$INITIAL_COMMIT_RANGE" == "HEAD" ]]; then
    CATEGORY_COMMITS=$(git log HEAD --pretty=format:"%h %s" | grep -E "$CATEGORY(\([^)]*\))?: " || true)
  else
    CATEGORY_COMMITS=$(git log "$INITIAL_COMMIT_RANGE" --pretty=format:"%h %s" | grep -E "$CATEGORY(\([^)]*\))?: " || true)
  fi

  if [[ -n "$CATEGORY_COMMITS" ]]; then
    RELEASE_NOTES+="**$UPPER_CATEGORY**
"
    while IFS= read -r LINE; do
      COMMIT_HASH=${LINE%% *}
      COMMIT_MSG=${LINE#* }
      # Remove 'category(scope):' prefix from commit message
      CLEAN_COMMIT_MSG=$(echo "$COMMIT_MSG" | sed -E 's/^[a-z]+\([^)]*\):\s*//; s/^[a-z]+:\s*//')
      SHORT_HASH=${COMMIT_HASH:0:5}
      COMMIT_LINK="[$SHORT_HASH]($REPO_URL/commit/$COMMIT_HASH)"
      RELEASE_NOTES+="* $COMMIT_LINK - $CLEAN_COMMIT_MSG
"
    done <<< "$CATEGORY_COMMITS"
    RELEASE_NOTES+="
"  # Add extra newline after each category block
  fi
done

# Provide a default message if no release notes are found
if [[ -z "$RELEASE_NOTES" || "$RELEASE_NOTES" == "### What's Changed\n\n" ]]; then
  RELEASE_NOTES="### What's Changed

No release notes."
fi

# Append full changelog link
RELEASE_NOTES+="

**Full Changelog**: [$LATEST_TAG...$NEW_TAG]($COMPARE_URL/$LATEST_TAG...$NEW_TAG)"

# Create the tag description
DESCRIPTION="[Release] Bump version to ${NEW_TAG}.

Change was created by the GitHub Actions and automation script."

# Uncomment the following lines to push the tag and create the GitHub release
git tag -a "$NEW_TAG" -m "$DESCRIPTION"
git push "$REMOTE" "$NEW_TAG"
gh release create "$NEW_TAG" --title "$NEW_TAG" --notes "$RELEASE_NOTES"

#!/bin/bash
set -e

# Configuration
RELEASE_TYPE=${RELEASE_TYPE:-"patch"}
DEFAULT_BRANCH="main"
REMOTE=${REMOTE:-"origin"}
CHANGELOG_FILE="CHANGELOG.md"
DATE=$(date +"%Y-%m-%d")
TEMP_FILE=".release-notes.tmp"

# Fetch latest tags and initialize variables
git fetch --tags "$REMOTE"
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure on main branch for release
if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
  echo "Switching to $DEFAULT_BRANCH for release..."
  git checkout "$DEFAULT_BRANCH"
  git pull "$REMOTE" "$DEFAULT_BRANCH"
fi

# Determine new version
IFS='.' read -r MAJOR MINOR PATCH <<< "${LATEST_TAG//[!0-9.]/}"
case "$RELEASE_TYPE" in
  major) ((MAJOR+=1)); MINOR=0; PATCH=0 ;;
  minor) ((MINOR+=1)); PATCH=0 ;;
  patch) ((PATCH+=1)) ;;
  *) echo "Invalid release type: $RELEASE_TYPE"; exit 1 ;;
esac
NEW_TAG="v$MAJOR.$MINOR.$PATCH"

# Create release notes from conventional commits
echo "Generating release notes for $NEW_TAG..."
echo -e "## $NEW_TAG ($DATE)\n" > "$TEMP_FILE"
git log "${LATEST_TAG}"..HEAD --pretty=format:"%s" \
  | grep -E "^(feat|fix|chore|docs|style|refactor|perf|test|ci|build)!?: " \
  | sed -E 's/^(feat|fix|chore|docs|style|refactor|perf|test|ci|build)(!?): (.+)$/- **\1**: \3/g' >> "$TEMP_FILE"

# Check if there are changes to release
if [ ! -s "$TEMP_FILE" ]; then
  echo "No conventional commits found since $LATEST_TAG. Aborting release."
  rm "$TEMP_FILE"
  exit 0
fi

# Append new release notes to CHANGELOG
echo -e "\n\n$(cat "$CHANGELOG_FILE")" >> "$TEMP_FILE"
mv "$TEMP_FILE" "$CHANGELOG_FILE"

# Commit and tag release
git add "$CHANGELOG_FILE"
git commit -m "chore(release): $NEW_TAG [skip ci]"
git tag -a "$NEW_TAG" -m "Release $NEW_TAG" -m "$(cat "$CHANGELOG_FILE")"
git push "$REMOTE" "$DEFAULT_BRANCH"
git push "$REMOTE" "$NEW_TAG"

# Completion message
echo "Release $NEW_TAG created, tagged, and changelog updated successfully."

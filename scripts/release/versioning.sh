#!/bin/bash
set -e

# Configurable variables
RELEASE_TYPE=${RELEASE_TYPE:-"patch"}    # Options: "major", "minor", "patch"
DEFAULT_BRANCH="main"
REMOTE=${REMOTE:-"origin"}

# Fetch latest tags and set default values
git fetch --tags "$REMOTE"
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure on default branch for release
if [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
  echo "Switching to $DEFAULT_BRANCH for release..."
  git checkout "$DEFAULT_BRANCH"
  git pull "$REMOTE" "$DEFAULT_BRANCH"
fi

# Increment version number based on release type
IFS='.' read -r MAJOR MINOR PATCH <<< "${LATEST_TAG//[!0-9.]/}"
case "$RELEASE_TYPE" in
  major) ((MAJOR+=1)); MINOR=0; PATCH=0 ;;
  minor) ((MINOR+=1)); PATCH=0 ;;
  patch) ((PATCH+=1)) ;;
  *) echo "Invalid release type: $RELEASE_TYPE"; exit 1 ;;
esac
NEW_TAG="v$MAJOR.$MINOR.$PATCH"

# Generate release notes from conventional commits
NOTES=$(git log "${LATEST_TAG}"..HEAD --pretty=format:"%s" \
  | grep -E "^(feat|fix|chore|docs|style|refactor|perf|test|ci|build)!?: " \
  | sed -E 's/^(feat|fix|chore|docs|style|refactor|perf|test|ci|build)(!?): (.+)$/- [\1] \3/g')

# Verify changes exist for a new release
if [ -z "$NOTES" ]; then
  echo "No conventional commits found for a release between ${LATEST_TAG} and HEAD."
  exit 1
fi

# Create release tag and commit
echo "Creating new release tag: $NEW_TAG"
echo -e "Release Notes:\n$NOTES"
git tag -a "$NEW_TAG" -m "Release $NEW_TAG" -m "$NOTES"

# Push tag to remote
echo "Pushing tag $NEW_TAG to $REMOTE"
git push "$REMOTE" "$NEW_TAG"

# Generate changelog file
CHANGELOG_FILE="CHANGELOG.md"
echo -e "## $NEW_TAG\n\n$NOTES\n\n$(cat $CHANGELOG_FILE)" > $CHANGELOG_FILE
git add "$CHANGELOG_FILE"
git commit -m "chore(release): Update changelog for $NEW_TAG"
git push "$REMOTE" "$DEFAULT_BRANCH"

# Final confirmation
echo "Release $NEW_TAG created, changelog updated, and all changes pushed successfully."

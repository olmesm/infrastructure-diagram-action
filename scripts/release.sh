#!/usr/bin/env bash

RELEASE_NOTES="$1"
VERSION="$(cat RELEASE)"
TAG="$(echo $VERSION | sed 's|v||')"
MAJOR="$(echo $VERSION | sed 's|v\([0-9]*\).*|v\1|')"
FILE_TEMPLATE="action.template.yml"
FILE_OUTPUT="action.yml"

if [[ ! $(git status --porcelain) ]]; then
  echo "[ERROR] Nothing to commit."
  exit 1
fi

if [[ ! "${VERSION}" ]]; then
  echo "[ERROR] Please enter a VERSION in the form of v<MAJOR>.<MINOR>.<PATCH>"
  exit 1
fi

if [[ ! "${RELEASE_NOTES}" ]]; then
  echo "[ERROR] Please enter a RELEASE_NOTES in the form of a \"string\""
  exit 1
fi

echo "# Generated from $FILE_TEMPLATE

" > $FILE_OUTPUT
sed "s|\$\$VERSION|$TAG|g" $FILE_TEMPLATE >> $FILE_OUTPUT

git add .
git commit -m "$RELEASE_NOTES"
git tag -a -m "$RELEASE_NOTES" "$VERSION"

git tag -d "$MAJOR"
git tag -a -m "$RELEASE_NOTES" "$MAJOR" --force
git push --follow-tags

gh release create "$VERSION" --notes "$RELEASE_NOTES"
gh release delete "$MAJOR" --yes
gh release create "$MAJOR" --notes "$RELEASE_NOTES"
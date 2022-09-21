#!/usr/bin/env bash

RELEASE_NOTES="$1"
VERSION=$(cat RELEASE)

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

git add .
git commit -m "$RELEASE_NOTES"
git tag -a -m "$RELEASE_NOTES" "$VERSION"
git push --follow-tags

gh release create "$VERSION" --notes "$RELEASE_NOTES"
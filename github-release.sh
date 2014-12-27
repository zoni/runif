#!/bin/bash

set -e

BUILDAREA=/build-source/build-area/

cd $BUILDAREA
echo "Creating release"
github-release release --tag "$GITHUB_RELEASE_TAG" --name "$GITHUB_RELEASE_NAME" --description "$GITHUB_RELEASE_DESCRIPTION"
for file in *; do
	echo "Uploading $file"
	github-release upload --tag "$GITHUB_RELEASE_TAG" --name "$file" --file "$file"
done

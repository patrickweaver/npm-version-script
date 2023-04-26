RELEASE_TYPE=$1

if [ "${RELEASE_TYPE}" != "patch" ] && [ "${RELEASE_TYPE}" != "minor" ] && [ "${RELEASE_TYPE}" != "major" ]; then
    echo "\033[1m\n\nError:\nMust specify release type, either \"patch\", \"minor\", or \"major\".\033[0m"
    echo "\nExample:"
    echo "./release.sh patch"
    exit 0
fi

echo "\033[1mCreating new npm-version-script $RELEASE_TYPE release\033[0m"

PREVIOUS_VERSION=$(npm pkg get version | xargs)
echo "\033[1m\nCurrent version is ${PREVIOUS_VERSION}\033[0m"

echo "\033[1m\nCreating new version...\033[0m"
npm version $RELEASE_TYPE

NEW_VERSION=$(npm pkg get version | xargs)

echo "\033[1m\nNew version $NEW_VERSION successfully created!\033[0m"

VERSION_PREFIX="v"
VERSION_TAG=$VERSION_PREFIX$NEW_VERSION

echo "\033[1m\nTagging current commit: $VERSION_TAG\033[0m"


echo "\033[1m\nPushing $VERSION_TAG tag to GitHub...\n\033[0m"
git push origin $VERSION_TAG

echo "\033[1m\nCreating $VERSION_TAG release on GitHub\033[0m"
gh release create $VERSION_TAG --verify-tag -n $VERSION_TAG -t $VERSION_TAG

echo "\033[1m\nNew $RELEASE_TYPE release successful, updated from ${CURRENT_VERSION} to ${NEW_VERSION}\033[0m"
#!/bin/bash
set -e
# This script will update the version of the project and commit the changes
# License: MIT
# Author: Dominik Fuchß (dfuchss)

CURRENT_VERSION=$(mvn help:evaluate -Dexpression="project.version" -q -DforceStdout)
VERSION=$(echo $CURRENT_VERSION | sed -e "s/-SNAPSHOT//g")
MAJOR=$(echo $VERSION | cut -d '.' -f1)
MINOR=$(echo $VERSION | cut -d '.' -f2)
PATCH=$(echo $VERSION | cut -d '.' -f3)

# Verify AUTO_DIGIT environment variable selection: Possible Options: Major, Minor, Patch. Default: Minor
if [[ $AUTO_DIGIT == "" ]]; then
    AUTO_DIGIT="Minor"
fi
if [[ $AUTO_DIGIT != "Major" && $AUTO_DIGIT != "Minor" && $AUTO_DIGIT != "Patch" ]]; then
    echo "Invalid AUTO_DIGIT value: $AUTO_DIGIT .. aborting. Allowed values: Major, Minor, or Patch"
    exit 1
fi


if [[ $RELEASE_VERSION == "" ]]; then
    echo "No release version specified .. defaulting to $MAJOR.$MINOR.$PATCH"
    RELEASE_VERSION="$MAJOR.$MINOR.$PATCH"
fi

if [[ $NEXT_VERSION == "" ]]; then
    if [[ $AUTO_DIGIT == "Major" ]]; then
        NEXT_VERSION="$((MAJOR+1)).0.0-SNAPSHOT"
    elif [[ $AUTO_DIGIT == "Minor" ]]; then
        NEXT_VERSION="$MAJOR.$((MINOR+1)).0-SNAPSHOT"
    elif [[ $AUTO_DIGIT == "Patch" ]]; then
        NEXT_VERSION="$MAJOR.$MINOR.$((PATCH+1))-SNAPSHOT"
    else 
        echo "Invalid AUTO_DIGIT value: $AUTO_DIGIT .. aborting. Allowed values: Major, Minor, or Patch"
        exit 1
    fi
    echo "No next version specified .. defaulting to $NEXT_VERSION"
fi

echo "Current version: $CURRENT_VERSION"
echo "Release version: $RELEASE_VERSION"
echo "Next version: $NEXT_VERSION"

if grep -q "<revision>.*<\/revision>" pom.xml; then
    echo "Revision property found"
    sed -i -e "s/<revision>.*<\/revision>/<revision>$RELEASE_VERSION<\/revision>/g" pom.xml
else
    echo "Revision property not found .. defaulting to project.version"

    if [[ $(grep -c "<version>$CURRENT_VERSION<\/version>" pom.xml) -ne 1 ]]; then
        echo "Multiple version lines exist .. aborting"
        exit 1
    fi

    sed -i -e "s/<version>$CURRENT_VERSION<\/version>/<version>$RELEASE_VERSION<\/version>/g" pom.xml
fi

# Verify that all tests pass
mvn -B verify
git commit --allow-empty -a -m "Release $RELEASE_VERSION"
git tag -a -m "Release $RELEASE_VERSION" "v$RELEASE_VERSION"

# Prepare for next development cycle

if grep -q "<revision>.*<\/revision>" pom.xml; then
    echo "Revision property found"
    sed -i -e "s/<revision>.*<\/revision>/<revision>$NEXT_VERSION<\/revision>/g" pom.xml
else
    echo "Revision property not found .. defaulting to project.version"

    if [[ $(grep -c "<version>$RELEASE_VERSION<\/version>" pom.xml) -ne 1 ]]; then
        echo "Multiple version lines exist .. aborting"
        exit 1
    fi

    sed -i -e "s/<version>$RELEASE_VERSION<\/version>/<version>$NEXT_VERSION<\/version>/g" pom.xml
fi

mvn -B verify
git commit --allow-empty -a -m "Prepare for next development cycle"

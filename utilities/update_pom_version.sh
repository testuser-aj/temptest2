#!/bin/bash

# This script updates the pom.xml files to the next version number.
# This script is meant to be run manually (not by Travis) after pushing the non-snapshot release to maven.

# Argument (optional):
#   $1: new version number for pom.xml files (do not include -SNAPSHOT, that is done automatically).
#   Providing no argument defaults to incrementing revision number from x.y.z to x.y.z+1-SNAPSHOT

# Get the previous maven project version.
CURRENT_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|\w+:)')
# Get list of directories for which pom.xml must be updated
module_folders=($(ls -d gcloud-java* .)) 

if [ "${CURRENT_VERSION##*-}" != "SNAPSHOT" ]; then
    # Update x.y.z to x.y.z+1-SNAPSHOT by default, or to a.b.c-SNAPSHOT, where a.b.c is given by user.
    DEFAULT_UPDATE="${CURRENT_VERSION%.*}.$((${CURRENT_VERSION##*.}+1))"
    NEW_SNAPSHOT_VERSION=${1:-$DEFAULT_UPDATE}-SNAPSHOT
    echo "Changing version from $CURRENT_VERSION to $NEW_SNAPSHOT_VERSION in pom.xml files"
    for item in ${module_folders[*]}
    do
        sed -i "0,/<version>$CURRENT_VERSION/s/<version>$CURRENT_VERSION/<version>$NEW_SNAPSHOT_VERSION/" ${item}/pom.xml
    done
else
    # Update from x.y.z-SNAPSHOT to x.y.z
    NEW_RELEASE_VERSION=${CURRENT_VERSION%%-*}
    for item in ${module_folders[*]}
    do
        sed -i "0,/<version>$CURRENT_VERSION/s/<version>$CURRENT_VERSION/<version>$NEW_RELEASE_VERSION/" ${item}/pom.xml
    done
fi

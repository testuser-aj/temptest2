#!/bin/bash

# This script updates the READMEs with the latest non-SNAPSHOT version number.
# Precondition: the version in pom.xml does not contain "SNAPSHOT" before running this script.  

# Example: Suppose that before running this script, the pom.xml reads 7.8.9.  This script will replace 
# all occurrences of <version>#.#.#</version> with <version>7.8.9</version> in the README files.

# Get the current maven project version.
RELEASED_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|\w+:)')

echo "Changing version to $RELEASED_VERSION in README files"

sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" gcloud-java/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" gcloud-java-core/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" gcloud-java-datastore/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" gcloud-java-examples/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*<\/version>/<version>${RELEASED_VERSION}<\/version>/g" gcloud-java-storage/README.md

git add README.md
git add gcloud-java/README.md
git add gcloud-java-core/README.md
git add gcloud-java-datastore/README.md
git add gcloud-java-examples/README.md
git add gcloud-java-storage/README.md
git config --global user.name "travis-ci"
git config --global user.email "travis@travis-ci.org"
git commit -m "Updating version in README files."
git push --quiet "https://${CI_DEPLOY_USERNAME}:${CI_DEPLOY_PASSWORD}@github.com/testuser-aj/temptest2.git" HEAD:master > /dev/null 2>&1

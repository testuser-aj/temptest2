#!/bin/bash

# This script is used by Travis-CI to publish artifacts (binary, sorce and javadoc jars) when releasing snapshots.
# This script is referenced in .travis.yml.

echo "Travis branch:       " ${TRAVIS_BRANCH}
echo "Travis pull request: " ${TRAVIS_PULL_REQUEST}
echo "Travis JDK version:  " ${TRAVIS_JDK_VERSION}
if [ "${TRAVIS_JDK_VERSION}" == "oraclejdk7" -a "${TRAVIS_BRANCH}" == "master" -a "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    mvn cobertura:cobertura coveralls:report

    SITE_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|\w+:)')
    if [ "${SITE_VERSION##*-}" != "SNAPSHOT" ]; then
        # Deploy site if not a SNAPSHOT
        git config --global user.name "travis-ci"
        git config --global user.email "travis@travis-ci.org"
        git clone --branch gh-pages --single-branch https://github.com/testuser-aj/temptest2/ tmp_gh-pages
        mkdir -p tmp_gh-pages/$SITE_VERSION
        mvn site -DskipTests=true
        mvn site:stage -DtopSiteURL=http://testuser-aj.github.io/temptest2/site/${SITE_VERSION}/
        cd tmp_gh-pages
        cp ../target/staging/$SITE_VERSION/* $SITE_VERSION/
        sed -i "s/{{SITE_VERSION}}/$SITE_VERSION/g" ${SITE_VERSION}/index.html # Update "Quickstart with Maven" to reflect version change
        git add $SITE_VERSION
        echo "<html><head><meta http-equiv=\"refresh\" content=\"0; URL='http://GoogleCloudPlatform.github.io/gcloud-java/${SITE_VERSION}/index.html'\" /></head><body></body></html>" > index.html
        git add index.html
        git commit -m "Added a new site for version $SITE_VERSION and updated the root directory's redirect."
        git config --global push.default simple
        git push --quiet "https://${CI_DEPLOY_USERNAME}:${CI_DEPLOY_PASSWORD}@github.com/testuser-aj/temptest2.git" > /dev/null 2>&1
    fi
else
    echo "Not deploying artifacts. This is only done with non-pull-request commits to master branch with Oracle Java 7 builds."
fi

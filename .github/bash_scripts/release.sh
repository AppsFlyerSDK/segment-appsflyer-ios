#!/bin/bash

releaseVersion=$1

sed -r -i '' "s/version_plugin = \'[0-9]+\.[0-9]+\.[0-9]+.*\'/version_plugin = \'$releaseVersion\'/g" segment-appsflyer-ios-qa.podspec
sed -i '' "s/s.name             = \"segment-appsflyer-ios-qa\"/s.name             = \"segment-appsflyer-ios\"/g" segment-appsflyer-ios-qa.podspec
mv segment-appsflyer-ios-qa.podspec segment-appsflyer-ios.podspec

sed -r -i '' "s/(.*pod \'segment-appsflyer-ios)-qa\'(.*)/\1\',\'$releaseVersion\'/g" examples/SwiftPodsSample/Podfile
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios)-qa\'(.*)/\1\',\'$releaseVersion\'/g" examples/ObjcPodsSample/Podfile

sed -i '' 's/^/* /' "releasenotes.$releaseVersion"
NEW_VERSION_RELEASE_NOTES=$(cat "releasenotes.$releaseVersion")
NEW_VERSION_SECTION="### $releaseVersion\n$NEW_VERSION_RELEASE_NOTES\n\n"
echo -e "$NEW_VERSION_SECTION$(cat RELEASENOTES.md)" > RELEASENOTES.md

rm -r "releasenotes.$releaseVersion"
#!/bin/bash

# releaseversion=$(grep 'version_release' .github/bash_scripts/Appsflyer-exact-version| cut -d" " -f3)
releaseversion=$1

sed -r -i '' "s/version_release = \'[0-9]+\.[0-9]+\.[0-9]+\'/version_release = \'$releaseversion\'/g" segment-appsflyer-ios.podspec

sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*)/\1,\'$releaseversion\'/g" examples/SwiftPodsSample/Podfile
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*)/\1,\'$releaseversion\'/g" examples/ObjcPodsSample/Podfile

desctiption_to_release_notes=$(cat "releasenotes.$releaseversion")
sed -i.bak "/# Release Notes/a \\
\\
### $releaseversion\\
* Updated iOS SDK to v$releaseversion\\
$desctiption_to_release_notes\\
" RELEASENOTES.md

rm -r RELEASENOTES.md.bak
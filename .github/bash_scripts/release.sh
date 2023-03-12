#!/bin/bash

releaseversion=$(grep 'version_release' Appsflyer-exact-version| cut -d" " -f3)

sed -r -i '' "s/version_release = \'[0-9]+\.[0-9]+\.[0-9]+\'/version_release = \'$releaseversion\'/g" segment-appsflyer-ios.podspec

sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*)/\1,\'$releaseversion\'/g" examples/SwiftPodsSample/Podfile
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*)/\1,\'$releaseversion\'/g" examples/ObjcPodsSample/Podfile
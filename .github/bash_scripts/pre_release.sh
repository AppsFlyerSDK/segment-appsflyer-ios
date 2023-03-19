#!/bin/bash

appsflyerlibversion=$1

sed -i '' "s/version_appsflyerLib = \'.*\'/version_appsflyerLib = \'$appsflyerlibversion\'/g" segment-appsflyer-ios.podspec

sed -r -i '' "s/(.*AppsFlyerLib.*)([0-9]+\.[0-9]+\.[0-9]+)(.*)/\1$appsflyerlibversion\3/g" Package.swift

sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*\'[0-9]+\.[0-9]+\.[0-9]+\')/\1,:podspec => \'\.\.\/\.\.\/segment-appsflyer-ios.podspec\'/g" examples/SwiftPodsSample/Podfile
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios\')(.*\'[0-9]+\.[0-9]+\.[0-9]+\')/\1,:podspec => \'\.\.\/\.\.\/segment-appsflyer-ios.podspec\'/g" examples/ObjcPodsSample/Podfile

sed -r -i '' "s/(## This is a Segment wrapper for AppsFlyer SDK that is built with iOS SDK v)(.*)/\1$appsflyerlibversion./g" README.md
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios.*)([0-9]+\.[0-9]+\.[0-9]+)(.*)/\1$appsflyerlibversion\3/g" README.md

touch "releasenotes.$appsflyerlibversion"

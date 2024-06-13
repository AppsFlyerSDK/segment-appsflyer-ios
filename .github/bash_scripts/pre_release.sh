#!/bin/bash

appsflyerLibVersion=$1
rcVersion=$2

sed -i '' "s/version_appsflyerLib = \'.*\'/version_appsflyerLib = \'$appsflyerLibVersion\'/g" segment-appsflyer-ios.podspec
sed -i '' "s/version_plugin = \'.*\'/version_plugin = \'$rcVersion\'/g" segment-appsflyer-ios.podspec
sed -i '' "s/s.name             = \"segment-appsflyer-ios\"/s.name             = \"segment-appsflyer-ios-qa\"/g" segment-appsflyer-ios.podspec
mv segment-appsflyer-ios.podspec segment-appsflyer-ios-qa.podspec

sed -r -i '' "s/(.*AppsFlyerLib.*)([0-9]+\.[0-9]+\.[0-9]+)(.*)/\1$appsflyerLibVersion\3/g" Package.swift

sed -r -i '' "s/(.*pod \'segment-appsflyer-ios)\'(.*\'[0-9]+\.[0-9]+\.[0-9]+\')/\1\',\'$rcVersion\'/g" examples/SwiftPodsSample/Podfile
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios)\'(.*\'[0-9]+\.[0-9]+\.[0-9]+\')/\1\',\'$rcVersion\'/g" examples/ObjcPodsSample/Podfile

sed -r -i '' "s/(## This is a Segment wrapper for AppsFlyer SDK that is built with iOS SDK v)(.*)/\1$appsflyerLibVersion./g" README.md
sed -r -i '' "s/(.*pod \'segment-appsflyer-ios.*)([0-9]+\.[0-9]+\.[0-9]+)(.*)/\1$appsflyerLibVersion\3/g" README.md

sed -r -i '' "s/(.*pluginVersion.*)([0-9]+\.[0-9]+\.[0-9]+)(.*)/\1$appsflyerLibVersion\3/g" segment-appsflyer-ios/Classes/SEGAppsFlyerIntegration.m

touch "releasenotes.$appsflyerLibVersion"

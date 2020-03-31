#!/bin/sh

REPO_ROOT=$(git rev-parse --show-toplevel)

xcodebuild -workspace ${REPO_ROOT}/SimulatorControl.xcworkspace  -scheme SimulatorControl -configuration Release clean archive -archivePath ${REPO_ROOT}/archive
xcodebuild -exportArchive -archivePath ${REPO_ROOT}/archive.xcarchive -exportOptionsPlist ${REPO_ROOT}/exportOptions.plist -exportPath ${REPO_ROOT}/build
rm -rf ${REPO_ROOT}/archive.xcarchive

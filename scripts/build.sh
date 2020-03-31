#!/bin/sh

REPO_ROOT=$(git rev-parse --show-toplevel)

xcodebuild -workspace ${REPO_ROOT}/SimulatorControl.xcworkspace -scheme SimulatorControl

#!/bin/sh

# Decrypt the file
gpg --quiet --batch --yes --decrypt --passphrase="$SECRET_PASSPHRASE" \
--output SimulatorControl/GoogleService-Info.plist SimulatorControl/GoogleService-Info.plist.gpg

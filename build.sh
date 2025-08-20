#!/bin/bash
set -e

# Find and increment the version number.
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' pubspec.yaml

# Commit and tag this change.
version=`grep 'version: ' pubspec.yaml | sed 's/version: //'`
git commit -m "Bump version to $version" pubspec.yaml
git tag $version

flutter build apk --release
mv build/app/outputs/flutter-apk/app-release.apk build/my_money_$version.apk

#storePassword=123456
#keyPassword=123456
#keyAlias=upload
#storeFile=/home/yashar/AndroidStudioProjects/personal_project/my_money_v3/my-money-v3-keystore.jks
#flutter build apk --release --dart-define-file=key.properties

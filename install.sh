#!/bin/sh
# Builds and installs to /Applications. Signs locally because this Mac has no Apple developer identity.
set -e
cd "$(dirname "$0")"
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -project note.xcodeproj -scheme note -configuration Release -derivedDataPath build CODE_SIGNING_ALLOWED=NO build -quiet
P=build/Build/Products/Release/note.app
codesign -f -s - --entitlements noteWidget.entitlements "$P/Contents/PlugIns/noteWidget.appex"
codesign -f -s - --entitlements note.entitlements "$P"
pkill -x note || true
rm -rf /Applications/note.app
ditto "$P" /Applications/note.app
# A second copy with the same bundle ID can hide the app from the Apps list.
LS=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
"$LS" -u "$PWD/$P" || true
rm -rf build
"$LS" -f /Applications/note.app
open /Applications/note.app

#!/bin/sh
# build.sh <label|starter> — export the clone's committed tree (without .claude/) and build it as committed.
# Same command for every label. Build errors are a result, never a fix.
set -u
R=~/Scratch/AppleEngineeringSystem/2026-11-27-larder-run; L="$1"; B="$R/assess-build/$L"
SRC_REPO="$R/$L"; [ "$L" = starter ] && SRC_REPO="$R/starter"
mkdir -p "$B/src"
FILES=$(git -C "$SRC_REPO" ls-tree -r --name-only HEAD | grep -v '^\.claude/')
git -C "$SRC_REPO" archive HEAD $FILES | tar -x -C "$B/src"
git -C "$SRC_REPO" rev-parse HEAD > "$B/commit"
cd "$B/src" && xcodebuild -project Larder.xcodeproj -scheme Larder \
  -destination 'platform=iOS Simulator,id=7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740' \
  -derivedDataPath "$B/dd" build > "$B/build.log" 2>&1
echo $? > "$B/build.exit"
grep -E ': warning: ' "$B/build.log" | sed -E 's#^.*/src/##' | sort -u > "$B/warnings.txt"
echo "$L exit $(cat $B/build.exit) warnings $(wc -l < $B/warnings.txt | tr -d ' ') $(tail -1 $B/build.log)"

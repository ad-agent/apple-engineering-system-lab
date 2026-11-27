#!/bin/sh
# Checks that the Apple skills the AES v0.3 skill routes to exist in the installed Xcode plugin, found the way the
# skill says (no stored path), and that the other Apple paths it gives resolve.
# Usage: sh check_apple_refs.sh [skill dir]
S="${1:-aes-v0.3/skills/apple-product-engineering}"
P="$(xcrun mcpbridge run-agent plugin path --plugin-format claude)" || { echo "FAIL plugin path"; exit 1; }
echo "plugin: $P ($(xcodebuild -version | tr '\n' ' '))"
fail=0; found=0
for n in $(ls "$P/skills"); do
  if grep -rq "\`\(xcode-integration:\)\{0,1\}$n\`" "$S"; then echo "ok   routed  $n"; found=$((found+1))
  else echo "--   unused  $n"; fi
done
# every backticked xcode-integration name in the skill must exist
for n in $(sed -n '/^| The task involves/,/^$/p' "$S/SKILL.md" | awk -F'|' 'NR>2{print $3}' | grep -oE '`[a-z0-9-]+`' | tr -d '`' | sort -u); do
  [ -f "$P/skills/$n/SKILL.md" ] || { echo "FAIL table names missing skill $n"; fail=1; }; done
for r in swiftui-specialist/references/animations.md swiftui-specialist/references/soft-deprecated-apis.md; do
  [ -f "$P/skills/$r" ] && echo "ok   file    $r" || { echo "FAIL file $r"; fail=1; }; done
A="$(xcode-select -p)/../PlugIns/IDEIntelligenceChat.framework/Versions/A/Resources/AdditionalDocumentation"
n=$(ls "$A"/*.md 2>/dev/null | wc -l | tr -d ' '); [ "$n" -gt 0 ] && echo "ok   AdditionalDocumentation: $n .md files" || { echo "FAIL AdditionalDocumentation"; fail=1; }
echo "routed $found of $(ls "$P/skills" | wc -l | tr -d ' ') Apple skills; exit $fail"; exit $fail

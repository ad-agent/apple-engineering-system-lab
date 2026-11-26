# AppleEngineeringSystem 0.1

A shared native Apple engineering skill for Codex and Claude Code. The supplied core is in skills/apple-product-engineering/SKILL.md with discovery metadata and an index to five focused references. Tag v0.1 pins the release.

| Path | Purpose |
|---|---|
| skills/apple-product-engineering/ | Installable skill and its references |
| verification/Availability.swift | Compile-only check of selected iOS APIs |
| evaluation/folio.md | Baseline intake, isolated checkout and participant brief |
| evaluation/holdouts.md | Two cross-application transfer tasks |
| evaluation/protocol.md | Assessor procedure and outcome measures |

## Install in an authorized project

From the root of a disposable or authorized project, choose one discovery directory below. Set SYSTEM to the absolute path of this release checkout. These commands copy the skill into the project and refuse an existing destination.

```sh
SYSTEM=/Users/x/Developer/AppleEngineeringSystem
DISCOVERY=.agents/skills     # Codex
# DISCOVERY=.claude/skills   # Claude Code
name=apple-product-engineering
mkdir -p "$DISCOVERY" &&
mkdir "$DISCOVERY/$name" &&
cp -R "$SYSTEM/skills/$name/." "$DISCOVERY/$name/"
```

Start a fresh session in the project. Select $apple-product-engineering in Codex or invoke /apple-product-engineering in Claude Code. Confirm the named skill is listed before a trial. To uninstall, remove only the copied apple-product-engineering directory. Install into a fresh project for each comparative trial.

[Codex skills](https://developers.openai.com/codex/skills/) · [Claude Code skills](https://code.claude.com/docs/en/skills)

## SDK check

Checked with Xcode 27.2 build 27B52, iPhoneOS SDK 27.2 and an iOS 16 deployment target. The probe type-checks pan translation and velocity, Reduce Motion, a SwiftUI spring and a selection feedback modifier guarded for iOS 17. Repeat from the repository root:

```sh
xcrun --sdk iphoneos swiftc -sdk "$(xcrun --sdk iphoneos --show-sdk-path)" \
  -target arm64-apple-ios16.0 -typecheck verification/Availability.swift
```

The references link the Apple documentation used to select APIs. Actual projects must check their own platform and deployment target. XCTest, Instruments, Git, the clients’ skill discovery and any existing project verification remain the execution mechanisms. Code Director’s existing verification workflow can consume normal project evidence. No integration is required for this release.

## Evaluation status

The SDK probe passed. Application trials, live agent activation, hardware feedback and comparative performance remain unmeasured. The Folio fixture requires the accepted revision and reference materials before trials can begin. Start with evaluation/folio.md and freeze the inputs before applying evaluation/protocol.md.

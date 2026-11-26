# Publication review

Before publication, the contents of this repository were reviewed for privacy, security and redistribution. This
file lists everything that was withheld or changed, and why. The submissions themselves (source, tests and project
files) are published unchanged.

## Withheld

| Item | Reason | Identity |
|---|---|---|
| `References/` reference recording and two annotated stills | They show the Claude iOS app (another company's product and branding) with the account holder's real conversation titles and personal greeting | SHA-256 in [`baseline/README.md`](baseline/README.md) |
| Composites and contact sheets that contain reference frames (Control A `matched-resting-views.png`, `ref/sheet*.png`, `ref-closed-chats.png`; B's reference sheets were already outside its package) | Same as above | — |
| Raw simulator recordings (`.mov`) and Control A's trimmed `.mp4` | They show the simulator home screen with unrelated private project apps; also size | Published as redacted transcodes |
| Control A `fail1.png`, `fail1b.png`, `fail2.png`, `recording-sheet.png`, `open-light2.png`, `small.png` | Home-screen frames, or duplicates | — |
| Session transcripts (both arms) | They contain private global instructions, local tool paths and unrelated account context | Session IDs listed; sanitized activation JSON published instead |
| xcresult bundles, DerivedData, build products | Size and machine-specific content; JSON summaries published instead | Retained locally |
| The `loupe` skill text that entered Control A's context | Private user-level tool | SHA-256 of the injected body in Control A's activation JSON |

## Changed

- **Recordings:** compressed with H.264 at 660 px and 30 fps. Home-screen frames are blacked out and the timeline
  is preserved. Labelled post-trial.
- **Control A motion strips:** new post-trial frame strips cut from the trial recording.
- **JSON test summaries:** exported after the trial from the unchanged result bundles.

## Checks performed

- **Secrets and personal-data scan** over every published text file, covering:
  - e-mail addresses
  - GitHub and API token shapes
  - key headers
  - account names
  - `password` / `keychain` / signing identity
  - private tool and project names
  - hostnames

  Findings and decisions:
  - Build logs contain `Signing Identity: "Sign to Run Locally"` (ad hoc simulator signing) and a
    `keychain-access-groups` entitlement key. Neither is secret.
  - Logs and reports keep absolute paths under the local user directory (`/Users/x/…`).
  - The brief's lock path `/tmp/edraft-checks.lock` and the names of the account holder's private tools appear in
    reports. They are names only. No source of those tools is included.
- **Visual review** of every composite sheet and of the recordings at 2 fps. An automated comparison of all 88
  single screenshots against home-screen frames found no match. Together these confirm that no home screen or
  reference frame remains.
- **Size:** no file in the repository exceeds 2 MB.

## Not done

- The submissions were not re-run or rebuilt.
- No defect was repaired.
- No test was modified.

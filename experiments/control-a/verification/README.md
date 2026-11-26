# Control A — test runs

Every run used the `Folio` scheme on the iPhone 18 Pro Max simulator `7EF1C8CB-EAEA-4605-92E6-D4FA5CFA1740`, with
`-derivedDataPath` in a scratch folder. Each `xcodebuild` ran inside `/usr/bin/lockf -k -t 0 /tmp/edraft-checks.lock`.

- **Logs** (`*.log`) are the trial-time console output.
- **JSON** (`*.summary.json`, `*.tests.json`) was exported after the trial with
  `xcrun xcresulttool get test-results summary|tests` from the unchanged trial xcresult bundles. The bundles are not
  published.

| Run | Source | Time (CET) | Result | Failing tests | Log |
|---|---|---|---|---|---|
| baseline | 7764604 (untouched copy) | 09:51:05–09:54:26 | 9/9 passed | — | [baseline-test.log](baseline-test.log) |
| build 1 | first implementation | 09:54:58 | build succeeded | — | [build1.log](build1.log) |
| run 1 | intermediate | 09:55:44–09:58:44 | 7/10 | spatial search, inbox/relaunch, reveal | [test1.log](test1.log) |
| run 2 | intermediate | 10:02:12–10:05:19 | 7/10 | spatial search, inbox/relaunch, reveal | [test2.log](test2.log) |
| run 3 | intermediate | 10:06:49–10:09:46 | 8/10 | spatial search, reveal | [test3.log](test3.log) |
| run 4 | intermediate | 10:11:21–10:14:59 | 9/10 | spatial search | [test4.log](test4.log) |
| run 5 | intermediate | 10:15:33–10:19:58 | 8/10 | spatial search, reveal | [test5.log](test5.log) |
| **run 6** | **final (`dcb54ae` content)** | 10:21:20–10:24:45 | **10/10 passed** | — | [test6.log](test6.log) |
| recording | final, dark appearance, reveal test only | 10:25:11–10:25:49 | 1/1 passed | — | [rec.log](rec.log) |

Run 6 has 10 tests: 4 public unit, 5 public UI and 1 new UI test (`testWorkspaceRevealKeepsCollectionState`). None
was skipped or excluded.

- **Warnings:** `Invalid frame dimension (negative or non-finite)` appears in four public UI tests in both the
  baseline and run 6. No quiescence stalls were logged.
- **Not measured:** performance profiling, and test runs on other text sizes, Reduce Motion, iPad or iOS 17.
- **Code changes after run 6:** none. The last production edit was at 10:21:09, before run 6 started.

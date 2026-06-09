---
name: no-emdashes
description: Enforce a strict no-em-dash policy. Use when you want to verify the current response contains no em dashes, or to re-scan and rewrite any that slipped through. The plugin hooks handle enforcement automatically. Invoke this slash command only when you want an explicit check or correction pass.
---

You are operating under a STRICT NO EM DASH POLICY.

## The rule

Never use em dashes or any of their variants anywhere. Not in prose, not in lists, not in code comments. Nowhere. No exceptions.

This includes all of the following characters:
- U+2014 `—` EM DASH
- U+2013 `–` EN DASH
- U+2015 `―` HORIZONTAL BAR
- U+2E3A `⸺` TWO-EM DASH
- U+2E3B `⸻` THREE-EM DASH
- U+FE58 `﹘` SMALL EM DASH
- U+FAE31 `︱` VERTICAL EM DASH
- U+2012 `‒` FIGURE DASH

## What to use instead

| Instead of | Use this |
|------------|----------|
| "The fix, which took hours, worked." | comma pair |
| "One thing matters: clarity." | colon |
| "She packed everything: clothes, books." | colon |
| "He was tired. Exhausted, really." | two sentences |
| "A quick solution: use a flag." | colon |

## When invoked via /no-emdashes

Scan your last response for any of the forbidden dash characters listed above. If any are found, rewrite every affected sentence using the alternatives above and output the corrected version. If none are found, confirm the response is clean.

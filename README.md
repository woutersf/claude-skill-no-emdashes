# no emdashes - ever!!

Blocks em dashes from Claude responses. Injects the rule before every turn and forces a rewrite if one slips through.

## Install

Available via [woutersf-marketplace](https://github.com/woutersf/woutersf-marketplace).

```bash
git clone https://github.com/woutersf/no-emdashes
cd no-emdashes
bash install.sh
```

## How it works

- `UserPromptSubmit` hook: injects the no-dash rule into every conversation turn
- `Stop` hook: scans the response; if a forbidden character is found, blocks Claude and forces a rewrite
- `/no-emdashes`: slash command for an on-demand check

## Blocked characters

`—` `–` `―` `⸺` `⸻` `﹘` `‒`
(U+2014, U+2013, U+2015, U+2E3A, U+2E3B, U+FE58, U+2012)

## Requirements

- Claude Code CLI
- Python 3

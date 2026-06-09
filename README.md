# no-emdashes

A Claude Code plugin that enforces a strict no-em-dash policy across all Claude responses.

## What it does

- **Injects a rule into every conversation turn** via a `UserPromptSubmit` hook, so Claude always has the no-dash rule in context before generating any response.
- **Checks every response** via a `Stop` hook. If a forbidden dash character is detected, Claude is blocked from finishing and told to rewrite the offending sentences.
- **Slash command** `/no-emdashes` for an on-demand scan and rewrite of the current response.

## Detected characters

| Character | Code point | Name |
|-----------|-----------|------|
| `—` | U+2014 | Em dash |
| `–` | U+2013 | En dash |
| `―` | U+2015 | Horizontal bar |
| `⸺` | U+2E3A | Two-em dash |
| `⸻` | U+2E3B | Three-em dash |
| `﹘` | U+FE58 | Small em dash |
| `‒` | U+2012 | Figure dash |

## Install via Claude Code marketplace

```
claude plugin install no-emdashes
```

## Manual install

```bash
git clone https://github.com/woutersf/no-emdashes
cd no-emdashes
bash install.sh
```

This adds the two hooks to your global `~/.claude/settings.json`.

## Uninstall

Remove the hook entries referencing `check-emdashes.sh` and `inject-instruction.sh` from `~/.claude/settings.json`.

## How the hooks work

| Hook | When | What it does |
|------|------|--------------|
| `UserPromptSubmit` | Before every Claude response | Injects the full forbidden-characters list as additional context |
| `Stop` | After every Claude response | Scans the transcript; if a forbidden dash is found, exits with code 2 to force a rewrite |

## Requirements

- Claude Code CLI
- Python 3

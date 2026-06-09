#!/usr/bin/env bash
# Manual installer for no-emdashes plugin.
# Run this if you're installing without the Claude Code marketplace.
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$PLUGIN_DIR/scripts"
SETTINGS_FILE="$HOME/.claude/settings.json"

chmod +x "$SCRIPTS_DIR/check-emdashes.sh"
chmod +x "$SCRIPTS_DIR/inject-instruction.sh"

if [ ! -f "$SETTINGS_FILE" ]; then
  mkdir -p "$(dirname "$SETTINGS_FILE")"
  echo '{}' > "$SETTINGS_FILE"
fi

python3 - "$SETTINGS_FILE" "$SCRIPTS_DIR" <<PYEOF
import json, sys

settings_file = sys.argv[1]
scripts_dir = sys.argv[2]

with open(settings_file) as f:
    settings = json.load(f)

hooks = settings.setdefault("hooks", {})

def already_registered(entries, marker):
    return any(
        marker in h.get("command", "")
        for entry in entries
        for h in entry.get("hooks", [])
    )

stop_hooks = hooks.setdefault("Stop", [])
if not already_registered(stop_hooks, "check-emdashes"):
    stop_hooks.append({
        "hooks": [{"type": "command", "command": f"{scripts_dir}/check-emdashes.sh"}]
    })

submit_hooks = hooks.setdefault("UserPromptSubmit", [])
if not already_registered(submit_hooks, "inject-instruction"):
    submit_hooks.append({
        "hooks": [{"type": "command", "command": f"{scripts_dir}/inject-instruction.sh"}]
    })

with open(settings_file, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")

print("no-emdashes hooks installed into", settings_file)
PYEOF

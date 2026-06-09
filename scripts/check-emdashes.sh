#!/usr/bin/env bash
# Stop hook: reads the last assistant message from the transcript and blocks
# Claude from stopping if an em dash (—) is found. Exit 2 feeds the message
# back to Claude as a user turn, prompting self-correction.
set -euo pipefail

INPUT=$(cat)

TRANSCRIPT=$(python3 -c "
import json, sys
try:
    data = json.loads(sys.argv[1])
    print(data.get('transcript_path', ''))
except Exception:
    print('')
" "$INPUT" 2>/dev/null || echo "")

if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  exit 0
fi

LAST_RESPONSE=$(python3 - "$TRANSCRIPT" <<'PYEOF'
import json, sys

path = sys.argv[1]
last_text = ""

with open(path) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
            if obj.get("type") == "assistant":
                content = obj.get("message", {}).get("content", [])
                if isinstance(content, list):
                    text = " ".join(
                        block.get("text", "")
                        for block in content
                        if isinstance(block, dict) and block.get("type") == "text"
                    )
                elif isinstance(content, str):
                    text = content
                else:
                    text = ""
                if text.strip():
                    last_text = text
        except (json.JSONDecodeError, KeyError):
            pass

print(last_text)
PYEOF
)

# Use Python to detect all em dash variants (avoids locale/encoding issues with grep)
FOUND=$(python3 -c "
import sys

# All em dash variants and common lookalikes
EM_DASH_CHARS = {
    '—': 'EM DASH (—)',
    '–': 'EN DASH (–)',
    '―': 'HORIZONTAL BAR (―)',
    '⸺': 'TWO-EM DASH (⸺)',
    '⸻': 'THREE-EM DASH (⸻)',
    '﹘': 'SMALL EM DASH (﹘)',
    '︱': 'VERTICAL EM DASH (︱)',
    '‒': 'FIGURE DASH (‒)',
}

text = sys.stdin.read()
found = [name for char, name in EM_DASH_CHARS.items() if char in text]
print(','.join(found))
" <<< "$LAST_RESPONSE")

if [ -n "$FOUND" ]; then
  echo "Your response contains dash characters that are not allowed: $FOUND. Remove every one and rewrite those sentences using commas, colons, parentheses, or separate sentences. These characters are never permitted."
  exit 2
fi

exit 0

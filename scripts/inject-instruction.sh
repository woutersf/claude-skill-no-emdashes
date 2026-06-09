#!/usr/bin/env bash
# UserPromptSubmit hook: injects the no-em-dash rule as additional context
# before every conversation turn so Claude sees it in every response cycle.
python3 -c "
import json
rule = (
    'STRICT RULE: Never use em dashes or any dash variant in your response. '
    'Forbidden characters include: '
    'em dash — (U+2014), '
    'en dash – (U+2013), '
    'horizontal bar ― (U+2015), '
    'two-em dash ⸺ (U+2E3A), '
    'three-em dash ⸻ (U+2E3B), '
    'small em dash ﹘ (U+FE58), '
    'figure dash ‒ (U+2012). '
    'No exceptions. Use commas, colons, parentheses, or separate sentences instead.'
)
print(json.dumps({
    'hookSpecificOutput': {
        'hookEventName': 'UserPromptSubmit',
        'additionalContext': rule
    }
}))
"

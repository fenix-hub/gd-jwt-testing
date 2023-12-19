#!/bin/sh -l

godot --headless --path "/test/src" -s test.gd --disable-render-loop --quit

passed=$(cat /test/src/passed)
table=$(cat /test/src/table)
echo "passed=$passed" >> "$GITHUB_OUTPUT"
echo "table=$table" >> "$GITHUB_OUTPUT"
echo "$table" >> "$GITHUB_STEP_SUMMARY"

exit 0

#!/bin/sh -l

godot --headless --path "/test/src" -s test.gd --disable-render-loop --quit

passed=$(cat $OUTPUT_PATH/passed)
table=$(cat $OUTPUT_PATH/table)
echo "passed=$passed" >> "$GITHUB_OUTPUT"
echo "table=$table" >> "$GITHUB_OUTPUT"
echo "$table" >> "$GITHUB_STEP_SUMMARY"

exit 0

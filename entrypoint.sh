#!/bin/sh -l

godot --headless --path "/test/src" -s test.gd --disable-render-loop --quit

passed=$(cat $OUTPUT_PATH/passed)
table=$(cat $OUTPUT_PATH/table)

echo "passed=$passed" >> "$GITHUB_OUTPUT"

EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
echo "table<<$EOF" >> $GITHUB_OUTPUT
echo "$table" >> $GITHUB_OUTPUT
echo "$EOF" >> $GITHUB_OUTPUT

echo "$table" >> "$GITHUB_STEP_SUMMARY"

exit 0

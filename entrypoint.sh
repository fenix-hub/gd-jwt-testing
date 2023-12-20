#!/bin/sh -l

godot --headless --path "/test/src" -s main.gd --disable-render-loop --quit

passed=$(cat "$OUTPUT_PATH"/passed)
table=$(cat "$OUTPUT_PATH"/table)
failures=$(cat "$OUTPUT_PATH"/failures)

echo "passed=$passed" >> "$GITHUB_OUTPUT"

EOF=$(dd if=/dev/urandom bs=15 count=1 status=none | base64)
{ 
    echo "table<<$EOF"
    echo "$table"
    echo "$EOF" 
}   >> "$GITHUB_OUTPUT"

{
    echo "failures<<$EOF"
    echo "$failures"
    echo "$EOF"
}   >> "$GITHUB_OUTPUT"

echo "$table" >> "$GITHUB_STEP_SUMMARY"
echo "$failures" >> "$GITHUB_STEP_SUMMARY"

if [ "$passed" = "false" ] ; then
    echo "Not all test passed"
    exit 1
fi
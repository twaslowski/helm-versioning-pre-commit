#!/bin/bash

set -e

# Directory to check
CHARTS_CHANGE_REGEX="charts/.*/templates"
CHART_FILE="Chart.yaml"

# Check if there are changes to any helm template (values.yaml excluded)
if ! git diff --cached --name-only | grep -q "^${CHARTS_CHANGE_REGEX}"; then
    exit 0
fi

# Find all Chart.yaml files that were modified
MODIFIED_CHART_FILES=$(git diff --cached --name-only | grep "charts/.*/templates" | cut -d '/' -f 1,2 | uniq)

for CHART_PATH in $MODIFIED_CHART_FILES; do
    FULLY_QUALIFIED_CHART_FILE="$CHART_PATH/$CHART_FILE"
    STAGED_VERSION=$(grep "^version:" "$FULLY_QUALIFIED_CHART_FILE" | awk '{print $2}')

    # Get the previous version from the last committed Chart.yaml
    PREVIOUS_VERSION=$(git show "HEAD:$FULLY_QUALIFIED_CHART_FILE" 2>/dev/null | grep "^version:" | awk '{print $2}')

    if [ -z "$PREVIOUS_VERSION" ]; then
        echo "No previous version found for $CHART_PATH. Assuming it's a new chart."
        continue
    fi

    # Compare versions
    if [ "$STAGED_VERSION" == "$PREVIOUS_VERSION" ]; then
        echo "Error: Version in $CHART_PATH has not been bumped. Current version: $STAGED_VERSION"
        echo "Please update the 'version' field in $CHART_PATH."
        exit 1
    fi
done

exit 0
# GitHub workflows are removed from the GitHub Actions tab only if they have all their executions removed.
# Because of this by renaming, developing and testing scripts they can accumulate in the left pane so that the UI starts to look overflown with unnecessary information.
# This script fetches all workflows that contain executions, compares them with the local .github/workflows folder contents and each workflows that doesn't exist anymore will be removed
# from GitHub actions tab along with its executions.
#!/bin/bash

# Fetch all run IDs for the specified workflow using --json for structured output
workflows=$(gh workflow list -a -L 1000 --json path | jq -r '.[].path' | xargs -n 1 basename)

# Loop through each run ID and delete it
for workflow in $workflows; do

    if [ -f "workflows/$workflow" ]; then
        echo "Workflow $workflow exists."
    else
        echo "Workflow $workflow does not exist."
        gh run list --limit 500 --workflow "$workflow" --json databaseId -q ".[].databaseId"  | xargs -n 1 gh run delete  
    fi
done

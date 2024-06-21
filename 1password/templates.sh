#!/bin/bash

# Function to process a single template
process_template() {
    local name="$1"
    echo "---"
    echo "template: $name"
    echo "fields:"
    
    # Get the template details and convert to YAML
    op item template get "$name" | glaze json - --output yaml | 
    sed '/.*: ""/d' | sed 's/^/  /'  # Remove empty lines and indent
    
    echo ""
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    # No arguments, process all templates
    templates=$(op item template list --format=json | jq -r '.[] | .name')
    while read -r name; do
        process_template "$name"
    done <<< "$templates"
else
    # Process specified templates
    for name in "$@"; do
        process_template "$name"
    done
fi


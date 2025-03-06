#!/bin/bash

# Script to set ACTIVE_PROJECT environment variable

# Define valid project names
declare -a VALID_PROJECTS=("stm32mp1-dk1" "central_hub" "doorbell")

# Get the project name from the first command-line argument
PROJECT_NAME="$1"

# Check if a project name was provided
if [[ -z "$PROJECT_NAME" ]]; then
  echo "Error: Project name not provided."
  echo "Usage: $0 <project_name>"
  echo "Valid project names are: ${VALID_PROJECTS[*]}"
  return 1
fi

# Remove all spaces and newline characters from the input
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr -d '[:space:]')

# Validate the project name against the list of valid projects
VALID_PROJECT=false
for valid_project in "${VALID_PROJECTS[@]}"; do
  if [[ "$PROJECT_NAME" == "$valid_project" ]]; then
    VALID_PROJECT=true
    break
  fi
done

# If the project name is valid, set ACTIVE_PROJECT and export it
if $VALID_PROJECT; then
  export ACTIVE_PROJECT="$PROJECT_NAME"
  echo "ACTIVE_PROJECT set to: '$ACTIVE_PROJECT'"
else
  echo "Error: Invalid project name: '$PROJECT_NAME'"
  echo "Valid project names are: ${VALID_PROJECTS[*]}"
  return 1
fi

return 0
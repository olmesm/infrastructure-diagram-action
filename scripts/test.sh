#!/usr/bin/env bash

GITHUB_BASE_REF="main"
INPUT_disable_review_comment="true"
GITHUB_WORKSPACE=$(pwd)
INPUT_input_dir="_documentation/diagrams"
INPUT_debug=true

. src/entrypoint.sh
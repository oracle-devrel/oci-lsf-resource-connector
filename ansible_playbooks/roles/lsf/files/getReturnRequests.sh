#!/bin/bash

# export LC_ALL=C.UTF-8
# export LANG=C.UTF-8

INPUT=$2
cp $INPUT /tmp/rr.json

cat <<EOF2
{"status":"complete","message":"Instances marked for termination retrieved successfully","requests":[]}
EOF2

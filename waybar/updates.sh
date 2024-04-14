#!/bin/bash

# Get the number of AUR updates available
aur_updates=$(rpm-ostree update | wc -l)
tooltip="There are $aur_updates updates available."
output="{\"text\": \"$aur_updates\", \"tooltip\": \"$tooltip\"}"
echo "$output" | jq --unbuffered --compact-output

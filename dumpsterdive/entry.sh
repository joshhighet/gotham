#!/bin/ash
# entrypoint for dumpster dive

# make a blank results file
touch /dd/creds.json
# execute Dumster Diver saving output to json and hiding stderr
python /dd/DumpsterDiver.py -s -p /dd/files -o /dd/creds.json >&/dev/null
# parse the results file and strip internal path '/dd/files/' from JSON
jq . /dd/creds.json | sed 's,"/dd/files,",g'

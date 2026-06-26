#!/usr/bin/env bash
# clean_netlist.sh — safe cleaning of escaped identifiers
# Input: vsdbabysoc_synth.cells_final.v
# Output: vsdbabysoc_synth.cells_final.clean2.v

IN="vsdbabysoc_synth.cells_final.v"
OUT="vsdbabysoc_synth.cells_final.clean2.v"

if [ ! -f "$IN" ]; then
  echo "ERROR: input $IN not found"
  exit 1
fi

cp "$IN" "${IN}.orig"

# Replace backslash-escaped identifiers: remove leading '\' and replace '.' with '_'
perl -0777 -pe 's{\\([^\s\)\(;,]+)}{ my $s=$1; ($s=~s/\./_/gr) }ge' "${IN}.orig" > "$OUT"

echo "Wrote $OUT (original saved as ${IN}.orig)"
ls -l "$OUT"

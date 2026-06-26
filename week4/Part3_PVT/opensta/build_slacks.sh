#!/usr/bin/env bash
# build_slacks.sh - create slacks.csv from available *_wns.txt and *_tns.txt
OUT=slacks.csv
echo "corner,wns,tns" > $OUT
for w in *_wns.txt; do
  corner=$(echo "$w" | sed -E 's/^(.*)_wns.txt$/\1/')
  wns=$(head -n1 "${corner}_wns.txt" 2>/dev/null || echo "N/A")
  tns=$(head -n1 "${corner}_tns.txt" 2>/dev/null || echo "N/A")
  echo "${corner},\"${wns}\",\"${tns}\"" >> $OUT
done
echo "Wrote $OUT"

#!/usr/bin/env bash
set -e
# run_sta_all_corners.sh — runs OpenSTA for FF/TT/SS corners
STA_BIN=~/OpenSTA/build/sta
TOP=avsddac
CLEAN_NET=./vsdbabysoc_synth.cells_final.clean.v
SDC=./vsdbabysoc.sdc

declare -A LIBMAP
LIBMAP[FF]=./timing_libs/sky130_fd_sc_hd__ff_100C_1v65.lib
LIBMAP[TT]=./timing_libs/sky130_fd_sc_hd__tt_025C_1v80.lib
LIBMAP[SS]=./timing_libs/sky130_fd_sc_hd__ss_n40C_1v28.lib

if [ ! -x "$STA_BIN" ]; then
  echo "ERROR: OpenSTA not found at $STA_BIN"
  exit 2
fi
if [ ! -f "$CLEAN_NET" ]; then
  echo "ERROR: cleaned netlist $CLEAN_NET not found"
  exit 3
fi
if [ ! -f "$SDC" ]; then
  echo "ERROR: SDC file $SDC not found"
  exit 4
fi

for corner in FF TT SS; do
  LIB=${LIBMAP[$corner]}
  OUT_PREFIX="timing_${corner,,}"   # e.g., timing_ff
  echo "=== Running OpenSTA for corner $corner (lib: $LIB) ==="
  printf "read_liberty $LIB\nread_verilog $CLEAN_NET\nlink_design $TOP\nread_sdc $SDC\nreport_checks > ${OUT_PREFIX}_report_checks.txt\nreport_timing -max_paths 20 > ${OUT_PREFIX}_timing_report.txt\nreport_wns -digits 4 > ${OUT_PREFIX}_wns.txt\nreport_tns -digits 4 > ${OUT_PREFIX}_tns.txt\nexit\n" \
    | $STA_BIN | tee ${OUT_PREFIX}_opensta_run.log
  echo "Outputs: ${OUT_PREFIX}_timing_report.txt ${OUT_PREFIX}_wns.txt ${OUT_PREFIX}_tns.txt"
done

# copy TT -> generic for convenience
if [ -f timing_tt_timing_report.txt ]; then cp -f timing_tt_timing_report.txt timing_report.txt; fi
if [ -f timing_tt_wns.txt ]; then cp -f timing_tt_wns.txt wns.txt; fi
if [ -f timing_tt_tns.txt ]; then cp -f timing_tt_tns.txt tns.txt; fi

echo "Done. Per-corner reports and wns/tns files are generated."

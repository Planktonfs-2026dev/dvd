#!/bin/bash
# Sweep CLOCK_PERIOD from 5.0 to 15.0 ns in 0.5 ns steps.
# Stops at the first period where setup, DRC and LVS all pass.
cd "$(dirname "$0")"
for p in $(seq 5.0 0.5 15.0); do
  sed -i -E "s/\"CLOCK_PERIOD\": [0-9.]+/\"CLOCK_PERIOD\": $p/" config.json
  echo "=== CLOCK_PERIOD = $p ns  ($(date +%H:%M)) ==="
  librelane config.json > run_${p}ns.log 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "  flow stopped (exit $rc): $(grep -m1 'Setup violations' run_${p}ns.log | sed 's/^ *//' || true)"
    echo "  setup violation or other flow error; see run_${p}ns.log"
    continue
  fi
  if python3 check_run.py run_${p}ns.log; then
    RUN=$(ls -td runs/*/ | head -1)
    cp "$RUN/final/metrics.json" .
    cp "$(find "$RUN/final" -name '*.gds' | head -1)" mult_array.gds
    echo "PASSED: setup, DRC and LVS all clean at $p ns"
    exit 0
  fi
  echo "  DRC or LVS not clean at $p ns; continuing"
done
echo "No period from 5.0 to 15.0 ns passed"
exit 1

#!/usr/bin/env bash
set -euo pipefail

INPUT="data/raw.txt"
METRICS="data/metrics.csv"
PARALLEL="${PARALLEL:-100}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

count=$(wc -l < "$INPUT" | tr -d ' ')
echo "validating $count resolvers (parallel: $PARALLEL)"

echo "ip,pass,avg_ms,tier" > "$METRICS"

xargs -P "$PARALLEL" -I {} "$SCRIPT_DIR/check.sh" {} < "$INPUT" >> "$METRICS"

validated=$(grep -c ",validated$\|,trusted$" "$METRICS" || true)
trusted=$(grep -c ",trusted$" "$METRICS" || true)

echo "done — $validated validated, $trusted trusted"

#!/usr/bin/env bash
set -euo pipefail

INPUT="data/raw.txt"
ALIVE="data/alive.txt"
METRICS="data/metrics.csv"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

count=$(wc -l < "$INPUT" | tr -d ' ')

# --- Pass 1: fast liveness filter ---
echo "pass 1 — liveness check on $count resolvers"

> "$ALIVE"
xargs -P 200 -I {} bash -c '
    ip="$1"
    r=$(dig @"$ip" google.com A +time=1 +tries=1 +short 2>/dev/null) || exit 0
    if echo "$r" | grep -qE "^[0-9]+\."; then echo "$ip"; fi
    exit 0
' _ {} < "$INPUT" >> "$ALIVE" || true

alive=$(wc -l < "$ALIVE" | tr -d ' ')
echo "pass 1 done — $alive alive out of $count"

[ "$alive" -eq 0 ] && echo "no resolvers passed liveness check" && exit 1

# --- Pass 2: full scoring on survivors ---
echo "pass 2 — scoring $alive resolvers"

echo "ip,pass,avg_ms,tier" > "$METRICS"
xargs -P 150 -I {} "$SCRIPT_DIR/check.sh" {} < "$ALIVE" >> "$METRICS" || true

validated=$(grep -c ",validated$\|,trusted$" "$METRICS" || true)
trusted=$(grep -c ",trusted$" "$METRICS" || true)

echo "done — $validated validated, $trusted trusted"

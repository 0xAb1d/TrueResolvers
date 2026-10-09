#!/usr/bin/env bash
set -euo pipefail

METRICS="data/metrics.csv"

awk -F, 'NR>1 && ($4=="trusted" || $4=="validated") {print $1}' "$METRICS" \
    | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n > resolvers.txt

awk -F, 'NR>1 && $4=="trusted" {print $1}' "$METRICS" \
    | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n > resolvers-trusted.txt

total=$(wc -l < resolvers.txt | tr -d ' ')
trusted=$(wc -l < resolvers-trusted.txt | tr -d ' ')
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > data/stats.json << EOF
{
  "total": $total,
  "trusted": $trusted,
  "updated": "$timestamp"
}
EOF

echo "$total resolvers, $trusted trusted — $timestamp"

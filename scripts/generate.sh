#!/usr/bin/env bash
set -euo pipefail

METRICS="data/metrics.csv"

# --- Generate resolver lists ---

awk -F, 'NR>1 && ($4=="trusted" || $4=="validated") {print $1}' "$METRICS" \
    | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n > resolvers.txt

awk -F, 'NR>1 && $4=="trusted" {print $1}' "$METRICS" \
    | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n > resolvers-trusted.txt

total=$(wc -l < resolvers.txt | tr -d ' ')
trusted=$(wc -l < resolvers-trusted.txt | tr -d ' ')
tested=$(wc -l < data/raw.txt 2>/dev/null | tr -d ' ')
tested=${tested:-0}
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
date_display=$(date -u +"%b %d, %Y %H:%M UTC")

# --- Stats JSON ---

cat > data/stats.json << EOF
{
  "total": $total,
  "trusted": $trusted,
  "tested": $tested,
  "updated": "$timestamp"
}
EOF

# --- Update README stats ---

if grep -q "<!-- STATS_START -->" README.md 2>/dev/null; then
    sed -n '1,/<!-- STATS_START -->/p' README.md > /tmp/readme-top.md

    cat > /tmp/readme-stats.md << STATS
<div align="center">
<table>
<tr>
<td align="center"><strong>$total</strong><br><sub>Validated</sub></td>
<td align="center"><strong>$trusted</strong><br><sub>Trusted</sub></td>
<td align="center"><strong>$tested</strong><br><sub>Tested</sub></td>
<td align="center"><strong>$date_display</strong><br><sub>Last Run</sub></td>
</tr>
</table>
</div>
STATS

    sed -n '/<!-- STATS_END -->/,$p' README.md > /tmp/readme-bottom.md

    cat /tmp/readme-top.md /tmp/readme-stats.md /tmp/readme-bottom.md > README.md
    rm -f /tmp/readme-top.md /tmp/readme-stats.md /tmp/readme-bottom.md
fi

echo "$total resolvers, $trusted trusted — $timestamp"

#!/usr/bin/env bash
set -euo pipefail

OUT="data"
mkdir -p "$OUT"

# --- Upstream sources ---

curl -sfL "https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt" \
    -o "$OUT/src-trickest.txt" || true
echo "trickest: $(wc -l < "$OUT/src-trickest.txt" 2>/dev/null | tr -d ' ') entries"

curl -sfL "https://public-dns.info/nameservers.txt" \
    -o "$OUT/src-publicdns.txt" || true
echo "public-dns: $(wc -l < "$OUT/src-publicdns.txt" 2>/dev/null | tr -d ' ') entries"

# --- Merge, extract IPv4, deduplicate, shuffle ---

cat "$OUT"/src-*.txt 2>/dev/null \
    | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort -u \
    | shuf > "$OUT/raw.txt"

total=$(wc -l < "$OUT/raw.txt" | tr -d ' ')
echo "total unique: $total"

if [ "$total" -lt 100 ]; then
    echo "fetch failed — too few resolvers ($total), aborting"
    exit 1
fi

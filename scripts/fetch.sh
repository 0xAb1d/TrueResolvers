#!/usr/bin/env bash
set -euo pipefail

OUT="data"
mkdir -p "$OUT"

# --- Trickest: primary source, keep all ---
curl -sfL "https://raw.githubusercontent.com/trickest/resolvers/main/resolvers.txt" \
    -o "$OUT/src-trickest.txt" || true

grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$OUT/src-trickest.txt" | sort -u > "$OUT/trickest-clean.txt"
echo "trickest: $(wc -l < "$OUT/trickest-clean.txt" | tr -d ' ') resolvers"

# --- public-dns.info: secondary, sample unique additions ---
curl -sfL "https://public-dns.info/nameservers.txt" \
    -o "$OUT/src-publicdns.txt" || true

grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$OUT/src-publicdns.txt" | sort -u > "$OUT/publicdns-clean.txt"
echo "public-dns: $(wc -l < "$OUT/publicdns-clean.txt" | tr -d ' ') resolvers"

# Remove IPs already in Trickest, take random 8000 unique additions
comm -23 "$OUT/publicdns-clean.txt" "$OUT/trickest-clean.txt" | shuf > "$OUT/publicdns-shuffled.txt"
head -8000 "$OUT/publicdns-shuffled.txt" > "$OUT/publicdns-sample.txt"

additions=$(wc -l < "$OUT/publicdns-sample.txt" | tr -d ' ')
echo "public-dns additions (not in trickest): $additions"

# --- Merge all Trickest + sampled public-dns additions, shuffle ---
cat "$OUT/trickest-clean.txt" "$OUT/publicdns-sample.txt" | shuf > "$OUT/raw.txt"

total=$(wc -l < "$OUT/raw.txt" | tr -d ' ')
echo "total to validate: $total"

if [ "$total" -lt 100 ]; then
    echo "fetch failed — too few resolvers"
    exit 1
fi

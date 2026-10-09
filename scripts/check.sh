#!/usr/bin/env bash
ip="$1"
[ -z "$ip" ] && exit 0

pass=0
total_ms=0

for domain in google.com cloudflare.com example.com; do
    output=$(dig @"$ip" "$domain" A +time=2 +tries=1 2>/dev/null) || continue

    if echo "$output" | grep -qE "[[:space:]]IN[[:space:]]+A[[:space:]]+[0-9]"; then
        pass=$((pass + 1))
        ms=$(echo "$output" | grep "Query time:" | head -1 | awk '{print $4}')
        total_ms=$((total_ms + ${ms:-0}))
    fi
done

[ "$pass" -lt 2 ] && exit 0

avg=$((total_ms / pass))
tier="validated"
[ "$pass" -eq 3 ] && [ "$avg" -le 200 ] && tier="trusted"

echo "$ip,$pass,$avg,$tier"

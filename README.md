<div align="center">

# TrueResolvers

**Production-grade DNS resolvers. Validated every 6 hours. Zero stale entries.**

<br>

![Pipeline](https://img.shields.io/github/actions/workflow/status/0xAb1d/TrueResolvers/update.yml?label=pipeline&style=flat-square)
![Resolvers](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2F0xAb1d%2FTrueResolvers%2Fmain%2Fdata%2Fstats.json&query=%24.total&label=resolvers&color=00d084&style=flat-square)
![Trusted](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2F0xAb1d%2FTrueResolvers%2Fmain%2Fdata%2Fstats.json&query=%24.trusted&label=trusted&color=0088ff&style=flat-square)
![Updated](https://img.shields.io/github/last-commit/0xAb1d/TrueResolvers?label=updated&style=flat-square)
![Stars](https://img.shields.io/github/stars/0xAb1d/TrueResolvers?style=flat-square)
![License](https://img.shields.io/github/license/0xAb1d/TrueResolvers?style=flat-square)

<br>

Most resolver lists are stale the moment you download them.<br>
TrueResolvers is different — every IP is live-tested, scored, and verified before it ships.

</div>

<br>

<!-- STATS_START -->
<div align="center">
<table>
<tr>
<td align="center"><strong>108</strong><br><sub>Validated</sub></td>
<td align="center"><strong>7</strong><br><sub>Trusted</sub></td>
<td align="center"><strong>19664</strong><br><sub>Tested</sub></td>
<td align="center"><strong>Oct 10, 2026 17:22 UTC</strong><br><sub>Last Run</sub></td>
</tr>
</table>
</div>
<!-- STATS_END -->

<br>

## Why TrueResolvers

Resolver lists decay fast. IPs go offline, get rate-limited, start returning garbage. A list that worked last week might fail a third of your queries today.

TrueResolvers runs a fully automated validation pipeline **4 times per day**:

- Every IP is queried against real domains with strict timeouts
- Only correct, verifiable DNS responses make the cut
- Resolvers are scored by accuracy and speed, then ranked into tiers
- Failures are dropped immediately — no grace period, no exceptions

**The result:** a resolver list you can use blindly.

## Quick Start

```bash
# All validated resolvers
curl -sL https://raw.githubusercontent.com/0xAb1d/TrueResolvers/main/resolvers.txt -o resolvers.txt

# Trusted tier — 100% accuracy, sub-200ms latency
curl -sL https://raw.githubusercontent.com/0xAb1d/TrueResolvers/main/resolvers-trusted.txt -o resolvers-trusted.txt
```

### Tool Integration

```bash
# massdns
massdns -r resolvers.txt -t A domains.txt -o S -w output.txt

# puredns
puredns resolve domains.txt -r resolvers-trusted.txt --rate-limit 500

# shuffledns
shuffledns -d target.com -w wordlist.txt -r resolvers.txt

# dnsx
dnsx -l domains.txt -r resolvers-trusted.txt -resp -o resolved.txt
```

## Resolver Tiers

| Tier | File | Criteria | Recommended For |
|------|------|----------|-----------------|
| **Validated** | `resolvers.txt` | ≥ 2/3 DNS queries return correct A records | High-volume enumeration where coverage matters most |
| **Trusted** | `resolvers-trusted.txt` | 3/3 accuracy, avg latency ≤ 200ms | Precision scans, targeted resolution, verification workflows |

## Pipeline

```
Sources → Aggregate → Deduplicate → Validate → Score → Publish
```

**Every 6 hours**, a fully automated GitHub Actions pipeline:

1. **Aggregates** resolvers from multiple public upstream sources
2. **Deduplicates** and normalizes the full candidate set
3. **Validates** each IP — DNS queries against 3 known domains, strict timeouts, correct-response verification
4. **Scores** by accuracy (query pass rate) and performance (avg response time in ms)
5. **Publishes** the validated set — everything that failed is purged

Per-resolver performance data is published in [`data/metrics.csv`](data/metrics.csv) — every IP, its pass count, average latency, and assigned tier. Nothing is hidden.

## Built For

- **Subdomain Enumeration** — reliable mass DNS resolution with massdns, puredns, shuffledns, dnsx
- **Attack Surface Management** — clean resolver infrastructure for continuous asset discovery and mapping
- **Bug Bounty Reconnaissance** — fast, accurate DNS resolution during target enumeration at scale
- **Penetration Testing** — verified resolvers for active DNS brute-forcing and zone analysis
- **Security Research** — stable DNS infrastructure for experiments, monitoring, and data collection
- **CTEM Workflows** — automated resolver feeds for continuous threat exposure management pipelines

## Files

| File | Contents |
|------|----------|
| [`resolvers.txt`](resolvers.txt) | All resolvers that passed validation |
| [`resolvers-trusted.txt`](resolvers-trusted.txt) | Top tier — 3/3 accuracy, sub-200ms average latency |
| [`data/metrics.csv`](data/metrics.csv) | Per-resolver scoring — IP, pass count, avg latency, tier |
| [`data/stats.json`](data/stats.json) | Aggregate stats for monitoring, badges, and integration |

## Sources & Attribution

Resolvers are aggregated from multiple established public DNS projects. Every IP is independently validated against live DNS queries — upstream inclusion does not guarantee inclusion here.

Full attribution: [SOURCES.md](SOURCES.md)

## License

[MIT](LICENSE)

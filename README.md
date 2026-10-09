<div align="center">

# TrueResolvers

**Validated public DNS resolvers. Tested every 6 hours.**

![Updated](https://img.shields.io/github/last-commit/0xAb1d/TrueResolvers?label=updated&style=flat-square)
![Resolvers](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2F0xAb1d%2FTrueResolvers%2Fmain%2Fdata%2Fstats.json&query=%24.total&label=resolvers&color=00d084&style=flat-square)
![Trusted](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2F0xAb1d%2FTrueResolvers%2Fmain%2Fdata%2Fstats.json&query=%24.trusted&label=trusted&color=0088ff&style=flat-square)
![License](https://img.shields.io/github/license/0xAb1d/TrueResolvers?style=flat-square)

</div>

---

Every IP in this list has been DNS-queried within the last 6 hours. Correct responses only. Dead resolvers are dropped automatically.

## Download

```bash
# all validated resolvers
curl -sL https://raw.githubusercontent.com/0xAb1d/TrueResolvers/main/resolvers.txt -o resolvers.txt

# trusted only — 100% accuracy, under 200ms
curl -sL https://raw.githubusercontent.com/0xAb1d/TrueResolvers/main/resolvers-trusted.txt -o resolvers-trusted.txt
```

Drop-in compatible with `massdns`, `puredns`, `shuffledns`, `dnsx`, and any tool that takes a resolver file.

## Files

| File | What it contains |
|------|------------------|
| `resolvers.txt` | All resolvers that passed validation |
| `resolvers-trusted.txt` | 3/3 accuracy, avg response under 200ms |
| `data/metrics.csv` | Per-resolver scoring — IP, pass rate, latency, tier |
| `data/stats.json` | Aggregate stats for badges and monitoring |

## Methodology

An automated pipeline runs **every 6 hours** via GitHub Actions:

1. **Aggregate** — pull from multiple public DNS resolver sources, deduplicate
2. **Test** — query each IP against 3 known domains, verify correct A records
3. **Score** — rank by accuracy (pass rate) and speed (avg response time)
4. **Publish** — commit the validated set, drop everything that failed

**Validation bar:**
- Minimum 2 of 3 queries must return valid A records
- Trusted tier: all 3 correct, average latency ≤ 200ms

## Use Cases

- Subdomain enumeration and DNS brute-forcing
- Attack surface discovery and asset mapping
- Bug bounty reconnaissance
- Large-scale DNS resolution
- Security research and monitoring

## Sources

Resolvers are aggregated from multiple public upstream projects. Each one is independently validated — upstream inclusion does not guarantee inclusion here.

Full attribution in [SOURCES.md](SOURCES.md).

## License

[MIT](LICENSE)

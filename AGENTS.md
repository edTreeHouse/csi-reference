# Contributor guidance

## Update mirrored living Reference files in tandem

The living CSI Reference is maintained in two repositories:

- `edTreeHouse/csi-reference`: `reference/`
- `edTreeHouse/collective-state-inference-website`: `site/reference/`

When editing a mirrored article or supporting file, update its counterpart in the other repository as part of the same task. Apply the intended, approved wording to both copies; do not restore outdated text merely to make them match.

The authoritative list of mirrored files is `scripts/check-website-sync.sh` in `edTreeHouse/csi-reference`. Consult that list before changing living Reference content.

Before reporting the task complete, compare the designated files with both checkouts available:

```bash
bash csi-reference/scripts/check-website-sync.sh csi-reference collective-state-inference-website
```

Coordinate the two repository changes and confirm that their final `main` versions match and the GitHub synchronization check passes. If access to either repository prevents completion, explicitly report the remaining counterpart update.

Preserve the fixed Edition 0.1 release, archival checksum manifests, DOI records, and release tags. Living Reference synchronization must not alter those archival objects.

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REFERENCE_DIR="$ROOT/reference"
mkdir -p "$REFERENCE_DIR"

BASE_URL="https://collectivestateinference.org/reference"
FILES=(
  collective-state-inference.html
  collective-state.html
  collective.html
  emergence.html
  composition-models.html
  observable-evidence.html
  validation.html
  collective-awareness.html
  collective-aware-ai-systems.html
  uncertainty-in-csi.html
  about-research-program.html
  editorial-citation-policy.html
  scholarly-sources.html
  citation-verification-audit.html
  changelog.html
  edition-0.1-archival-release.html
  reuse-licensing.html
  scholarly-feedback.html
)

for file in "${FILES[@]}"; do
  curl --fail --silent --show-error --location \
    "$BASE_URL/$file" \
    --output "$REFERENCE_DIR/$file"
done

python3 - <<'PY'
from __future__ import annotations

import hashlib
import json
from pathlib import Path

root = Path.cwd()
paths = sorted(
    [p for p in (root / "reference").glob("*.html")]
    + [root / "README.md", root / "CITATION.cff", root / ".zenodo.json", root / "LICENSE-CONTENT.md"]
)
records = []
for path in paths:
    records.append(
        {
            "path": path.relative_to(root).as_posix(),
            "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
        }
    )
manifest = {
    "release": "CSI Reference Edition 0.1",
    "edition": "0.1",
    "release_date": "2026-07-30",
    "author": "Edward D. Clark",
    "publisher": "Collective-State Inference Research Program",
    "canonical_reference": "https://collectivestateinference.org/reference/",
    "license": "CC BY-NC 4.0",
    "license_url": "https://creativecommons.org/licenses/by-nc/4.0/",
    "research_status": "foundational conceptual release; not yet peer reviewed or empirically validated",
    "doi": None,
    "article_versions": {f"RA-{n:03d}": "0.2" for n in range(1, 11)},
    "files": records,
}
(root / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
print(f"Prepared Edition 0.1 with {len(records)} checksummed source files.")
PY

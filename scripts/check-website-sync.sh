#!/usr/bin/env bash
set -euo pipefail

REFERENCE_ROOT="${1:-.}"
WEBSITE_ROOT="${2:-../collective-state-inference-website}"

# Living-source files intentionally mirrored between the governed Reference
# repository and the public website. Archived Edition 0.1 metadata, manifests,
# checksums, DOI records, and release tags are deliberately excluded.
FILES=(
  "index.html"
  "collective-state-inference.html"
  "validation.html"
  "ground-truth-problem.html"
  "ra001-relationship-map.css"
  "validation-relationship-map.css"
  "citation-graph.css"
)

status=0

for file in "${FILES[@]}"; do
  reference_file="${REFERENCE_ROOT}/reference/${file}"
  website_file="${WEBSITE_ROOT}/site/reference/${file}"

  if [[ ! -f "${reference_file}" ]]; then
    echo "::error file=reference/${file}::Governed Reference file is missing."
    status=1
    continue
  fi

  if [[ ! -f "${website_file}" ]]; then
    echo "::error::Website counterpart is missing: site/reference/${file}"
    status=1
    continue
  fi

  if ! diff -u --label "csi-reference/reference/${file}" \
      --label "website/site/reference/${file}" \
      "${reference_file}" "${website_file}"; then
    echo "::error file=reference/${file}::Living Reference source has drifted from the website counterpart."
    status=1
  else
    echo "Aligned: ${file}"
  fi
done

if [[ "${status}" -ne 0 ]]; then
  cat <<'EOF'

Synchronization check failed.

Update the designated file in both repositories, or deliberately revise the
file list in scripts/check-website-sync.sh when governance responsibilities
change. Do not resolve drift by modifying Edition 0.1 archival metadata.
EOF
  exit "${status}"
fi

echo "All designated living CSI Reference files are synchronized."

#!/usr/bin/env bash
set -euo pipefail

REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
BASE_PKG_DIR="app/src/main/java/de/codevoid"

echo "Personalizing repository: ${REPO_NAME}"

# Substitute __TEMPLATE_NAME__ in all relevant files
# Use sed -i.bak for cross-platform compatibility (GNU sed and BSD/macOS sed)
find . -type f \( -name "*.kts" -o -name "*.md" -o -name "*.yml" -o -name "*.kt" -o -name "*.xml" \) \
  ! -path "./.git/*" \
  -exec sed -i.bak "s/__TEMPLATE_NAME__/${REPO_NAME}/g" {} +
find . -name "*.bak" ! -path "./.git/*" -delete

# Rename any package directory that still has the placeholder name
TEMPLATE_PKG_DIR="${BASE_PKG_DIR}/__TEMPLATE_NAME__"
TARGET_PKG_DIR="${BASE_PKG_DIR}/${REPO_NAME}"

if [ -d "${TEMPLATE_PKG_DIR}" ]; then
  mv "${TEMPLATE_PKG_DIR}" "${TARGET_PKG_DIR}"
  echo "Renamed package directory to: ${TARGET_PKG_DIR}"
fi

# Remove the template setup workflow
if [ -f ".github/workflows/template-setup.yml" ]; then
  rm .github/workflows/template-setup.yml
  echo "Removed template-setup.yml"
fi

echo "Done."

#!/usr/bin/env bash
set -euo pipefail

REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

echo "Personalizing repository: ${REPO_NAME}"

# Substitute __TEMPLATE_NAME__ in all relevant files
find . -type f \( -name "*.kts" -o -name "*.md" -o -name "*.yml" -o -name "*.kt" -o -name "*.xml" \) \
  ! -path "./.git/*" \
  -exec sed -i "s/__TEMPLATE_NAME__/${REPO_NAME}/g" {} +

# Rename package directory if it still has the placeholder name
TEMPLATE_PKG_DIR="app/src/main/java/de/codevoid/__TEMPLATE_NAME__"
TARGET_PKG_DIR="app/src/main/java/de/codevoid/${REPO_NAME}"

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

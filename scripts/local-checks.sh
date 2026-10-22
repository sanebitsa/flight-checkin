#!/usr/bin/env bash
# Shared local pre-commit/pre-push quality gate; keep aligned with Python CI.
set -euo pipefail

# Fail closed when quality tools are missing, rather than silently skipping checks.
ruff check --output-format=github .
ruff format --check .
pyright

if [[ -d tests ]] && find tests -type f \\( -name 'test_*.py' -o -name '*_test.py' \\) -print -quit | grep -q .; then
  python -m pytest -q
elif [[ -f checkin.py || -d airlines ]]; then
  echo "ERROR: Application code exists but no tests were found under tests/." >&2
  exit 1
else
  echo "NOTICE: No application code or tests yet; Pytest skipped until FC-001."
fi

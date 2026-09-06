#!/usr/bin/env bash
set -euo pipefail

changed_files=$(git diff --cached --name-only --diff-filter=ACMR)

if [[ -z "$changed_files" ]]; then
  exit 0
fi

has_dotnet=false
has_react=false
has_python=false
while IFS= read -r file; do
  case "$file" in
    *.cs|*.csproj|*.sln|*.slnx) has_dotnet=true ;;
    *.js|*.jsx|*.ts|*.tsx) has_react=true ;;
    *.py) has_python=true ;;
  esac
done <<< "$changed_files"

if $has_dotnet; then
  command -v dotnet >/dev/null || { echo 'dotnet is required for staged .NET changes'; exit 1; }
  dotnet format --verify-no-changes --verbosity minimal
fi

if $has_react; then
  command -v npm >/dev/null || { echo 'npm is required for staged React changes'; exit 1; }
  mapfile -t react_files < <(printf '%s\n' "$changed_files" | grep -E '\.(js|jsx|ts|tsx)$' || true)
  if ((${#react_files[@]})); then
    npx eslint "${react_files[@]}"
    npx prettier --check "${react_files[@]}"
  fi
fi

if $has_python; then
  command -v python >/dev/null || { echo 'python is required for staged Python changes'; exit 1; }
  mapfile -t python_files < <(printf '%s\n' "$changed_files" | grep -E '\.py$' || true)
  if ((${#python_files[@]})); then
    python -m black --check "${python_files[@]}"
    python -m pytest -q
  fi
fi

echo 'Pre-commit checks passed.'

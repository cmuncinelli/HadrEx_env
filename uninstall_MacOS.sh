#!/usr/bin/env bash
# Uninstall the HadrEx minimal (analysis) environment (macOS).
# Author: Cicero D. Muncinelli
# Date: 2026-02-05
#
# This script reverses the actions of install_MacOS.sh.
# It removes:
#  - the HadrEx conda environment
#  - the Miniforge installation at ~/.conda
#  - modifications made to ~/.zshrc
#
# WARNING:
# This will permanently delete ~/.conda if it was created by the installer.

set -e  # Exit immediately on error

### --- Safety check ---
echo
echo "This script will REMOVE the HadrEx conda environment and Miniforge installation."
echo "This includes deleting: $HOME/.conda"
echo "and restoring ~/.zshrc from ~/.zshrc_backup if available."
echo
read -p "Are you sure you want to continue? [y/N] " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Uninstall aborted."
  exit 0
fi

### --- Identify environment name from YAML ---
BASEDIR="$(pwd)"

if [[ ! -f "${BASEDIR}/packages_MacOS.yaml" ]]; then
  echo "packages_MacOS.yaml not found in current directory."
  echo "Please run this script from the repository root."
  exit 1
fi

ENV_NAME=$(awk '/^name:/ {print $2}' "${BASEDIR}/packages_MacOS.yaml")

echo
echo "Detected environment name: ${ENV_NAME}"

#### For group use safety:
if [[ "$HOME" == "/" ]]; then
  echo "Refusing to run in HOME=/"
  exit 1
fi

### --- Remove auto-activation from .zshrc ---
if [[ -f "$HOME/.zshrc" ]]; then
  if grep -Fxq "conda activate ${ENV_NAME}" "$HOME/.zshrc"; then
    echo "Removing auto-activation from ~/.zshrc"
    # macOS sed requires an empty extension for -i
    sed -i '' "/conda activate ${ENV_NAME}/d" "$HOME/.zshrc"
  fi
else
  echo "~/.zshrc not found — skipping auto-activation removal."
fi

### --- Restore .zshrc backup if available ---
if [[ -f "$HOME/.zshrc_backup" ]]; then
  echo "Restoring ~/.zshrc from backup"
  cp "$HOME/.zshrc_backup" "$HOME/.zshrc"
  rm "$HOME/.zshrc_backup"
else
  echo "No ~/.zshrc_backup found — leaving ~/.zshrc as-is."
fi

### --- Remove conda environment ---
if [[ -d "$HOME/.conda" ]]; then
  export PATH="$HOME/.conda/bin:$PATH"
  CONDA="$HOME/.conda/bin/conda"

  if "$CONDA" env list | awk '{print $1}' | grep -Fxq "${ENV_NAME}"; then
    echo "Removing conda environment: ${ENV_NAME}"
    "$CONDA" env remove -n "${ENV_NAME}" -y
  else
    echo "Conda environment ${ENV_NAME} not found."
  fi
else
  echo "~/.conda not found — skipping environment removal."
fi

### --- Remove Miniforge installation ---
if [[ -d "$HOME/.conda" ]]; then
  echo "Removing Miniforge installation at ~/.conda"
  rm -rf "$HOME/.conda"
fi

### --- Final message ---
echo
echo "Uninstallation complete."
echo "Please open a new terminal session (or run: exec zsh)."
echo "If something looks off, you can manually inspect ~/.zshrc."

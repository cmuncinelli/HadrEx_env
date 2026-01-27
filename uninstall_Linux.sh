#!/usr/bin/env bash
# Uninstall the HadrEx minimal (analysis) environment.
# Author: Cicero D. Muncinelli
# Date: 2026-01-26
# This script reverses the actions of install_Linux.sh.
# It removes:
#  - the HadrEx conda environment
#  - the Miniforge installation at ~/.conda
#  - modifications made to ~/.bashrc
#
# WARNING:
# This will permanently delete ~/.conda if it was created by the installer.

set -e  # Exit immediately on error

### --- Safety check ---
echo " This script will REMOVE the HadrEx conda environment and Miniforge installation."
echo "    This includes deleting: $HOME/.conda and returning to ~/.bashrc_backup, if available."
read -p "Are you sure you want to continue? [y/N] " CONFIRM

if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Uninstall aborted."
  exit 0
fi

### --- Identify environment name from YAML ---
BASEDIR="$(pwd)"

if [ ! -f "${BASEDIR}/packages_Linux.yaml" ]; then
  echo "packages_Linux.yaml not found in current directory."
  echo "Please run this script from the repository root."
  exit 1
fi

ENV_NAME=$(grep -E "^name:" packages_Linux.yaml | awk '{print $2}')

echo "Detected environment name: ${ENV_NAME}"

### --- Remove auto-activation from .bashrc ---
if grep -Fxq "conda activate ${ENV_NAME}" "$HOME/.bashrc"; then
  echo "Removing auto-activation from ~/.bashrc"
  sed -i "/conda activate ${ENV_NAME}/d" "$HOME/.bashrc"
fi

### --- Restore .bashrc backup if available ---
if [ -f "$HOME/.bashrc_backup" ]; then
  echo "Restoring ~/.bashrc from backup"
  cp "$HOME/.bashrc_backup" "$HOME/.bashrc"
  rm "$HOME/.bashrc_backup"
else
  echo "No ~/.bashrc_backup found — leaving ~/.bashrc as-is."
fi

### --- Remove conda environment ---
if [ -d "$HOME/.conda" ]; then
  export PATH="$HOME/.conda/bin:$PATH"

  if "$HOME/.conda/bin/conda" env list | grep -q "${ENV_NAME}"; then
    echo "Removing conda environment: ${ENV_NAME}"
    conda env remove -n "${ENV_NAME}" -y
  else
    echo "Conda environment ${ENV_NAME} not found."
  fi
else
  echo "~/.conda not found — skipping environment removal."
fi

### --- Remove Miniforge installation ---
if [ -d "$HOME/.conda" ]; then
  echo "Removing Miniforge installation at ~/.conda"
  rm -rf "$HOME/.conda"
fi

### --- Final message ---
echo
echo "Uninstallation complete."
echo "You may want to open a new terminal session."
echo "If something looks off, you can manually inspect ~/.bashrc."



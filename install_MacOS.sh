#!/usr/bin/env bash
# Install the *minimal* (analysis) environment used in the hadrex group (macOS).
# Author: Cicero D. Muncinelli
# Date: 2026-01-26
# Uses the mamba environment solver for quick installs.
# Based off the HadrEx_Ph repo installation.
#
# Supports:
#  - Apple Silicon Macs (ARM64)
#  - Intel Macs (x86_64)
#
# Notes for Ubuntu users:
#  - Default shell on macOS is zsh
#  - We modify ~/.zshrc (not ~/.bashrc)

set -e  # Exit immediately on error

### --- Backup .zshrc (we will touch it) ---
if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc_backup" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc_backup"
fi

BASEDIR="$(pwd)"

### --- Detect macOS architecture ---
ARCH="$(uname -m)"

case "${ARCH}" in
  arm64)
    MINIFORGE=Miniforge3-MacOSX-arm64.sh
    ;;
  x86_64)
    MINIFORGE=Miniforge3-MacOSX-x86_64.sh
    ;;
  *)
    echo "Unsupported macOS architecture: ${ARCH}"
    echo "This installer supports arm64 (Apple Silicon) and x86_64 (Intel) only."
    exit 1
    ;;
esac

### --- Install Miniforge (conda-forge + mamba by default) ---
# Better than installing miniconda, manually setting conda-forge as default,
# and installing the libmamba solver separately.
curl -L -o ${MINIFORGE} \
  https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE}

chmod +x ${MINIFORGE}
./${MINIFORGE} -b -p "$HOME/.conda"
rm ${MINIFORGE}

### --- Initialize conda (zsh) ---
export PATH="$HOME/.conda/bin:$PATH"
"$HOME/.conda/bin/conda" init zsh
source "$HOME/.zshrc"

### --- Make sure base is up to date ---
mamba update -n base -y mamba conda

### --- Create environment ---
mamba env create -f "${BASEDIR}/install/packages_MacOS.yaml"

### --- Auto-activate environment (avoid duplicates) ---
# Checking if the "conda activate hadrex" line is already in the .zshrc
ENV_NAME=$(grep -E "^name:" install/packages_MacOS.yaml | awk '{print $2}')

if ! grep -Fxq "conda activate ${ENV_NAME}" "$HOME/.zshrc"; then
  echo "conda activate ${ENV_NAME}" >> "$HOME/.zshrc"
fi

echo "Installation complete! Open a new terminal or run:"
echo "   conda activate ${ENV_NAME}"
echo "Thank you for waiting, and happy coding!"
echo "(If you do not want to open the HadrEx environment automatically on each new terminal session, remove the \"conda activate ${ENV_NAME}\" line from \"$HOME/.zshrc\")"


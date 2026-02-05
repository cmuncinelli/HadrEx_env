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

### --- Use conda explicitly (no sourcing of shell init files) ---
export PATH="$HOME/.conda/bin:$PATH"
CONDA="$HOME/.conda/bin/conda"
MAMBA="$HOME/.conda/bin/mamba"

### --- Initialize conda for future shells (do NOT source .zshrc) ---
"$CONDA" init zsh

### --- Make sure base environment is up to date ---
"$MAMBA" update -n base -y conda mamba

### --- Clean caches (cheap insurance) ---
"$CONDA" clean --all -y

### --- Create environment ---
# arm64 architectures were unstable using mamba, so now we revert to conda.
# Slower, but less aggressive with memory, thus more stable.
if [[ "$ARCH" == "arm64" ]]; then
  echo "Apple Silicon detected (arm64)."
  echo "Using conda for environment creation (mamba unstable on macOS arm64)."
  "$CONDA" env create -f "${BASEDIR}/packages_MacOS.yaml" -y
else
  echo "Intel macOS detected (x86_64)."
  echo "Using mamba for environment creation."
  "$MAMBA" env create -f "${BASEDIR}/packages_MacOS.yaml" -y
fi

### --- Auto-activate environment (avoid duplicates) ---
ENV_NAME=$(grep -E "^name:" packages_MacOS.yaml | awk '{print $2}')

# Checking if the "conda activate hadrex" line is already in the .zshrc
if ! grep -Fxq "conda activate ${ENV_NAME}" "$HOME/.zshrc"; then
  echo "conda activate ${ENV_NAME}" >> "$HOME/.zshrc"
fi

echo
echo "Environment created successfully."
"$CONDA" env list

echo "Installation complete! Open a new terminal or run:"
echo "   conda activate ${ENV_NAME}"
echo "Thank you for waiting, and happy coding!"
echo "(To disable auto-activation of the HadrEx environment, remove the \"conda activate ${ENV_NAME}\" line from \"$HOME/.zshrc\")"


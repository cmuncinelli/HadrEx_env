#!/usr/bin/env bash
# Install the *minimal* (analysis) enviroment used in the hadrex group.
# Author: Cicero D. Muncinelli
# Date: 2026-01-26
# Uses the mamba environment solver for quick installs.
# Based off the HadrEx_Ph repo installation.

set -e  # Exit immediately on error

### --- Backup .bashrc (we will touch it) ---
if [ ! -f "$HOME/.bashrc_backup" ]; then
  cp "$HOME/.bashrc" "$HOME/.bashrc_backup"
fi

BASEDIR=$PWD

BASEDIR="$(pwd)"

### --- Install Miniforge (conda-forge + mamba by default) ---
# Better than installing miniconda, manually setting conda-forge as default, and installing the libmamba solver separately.
# By the way, mamba is a solver written in C, so much faster than regular miniconda! 
MINIFORGE=Miniforge3-Linux-x86_64.sh

wget -q https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE}
chmod +x ${MINIFORGE}
./${MINIFORGE} -b -p "$HOME/.conda"
rm ${MINIFORGE}

### --- Initialize conda ---
export PATH="$HOME/.conda/bin:$PATH"
"$HOME/.conda/bin/conda" init bash
source "$HOME/.bashrc"

### --- Make sure base is up to date ---
mamba update -n base -y mamba conda

### --- Create environment ---
mamba env create -f "${BASEDIR}/install/packages_Linux.yaml"

### --- Auto-activate environment (avoid duplicates) ---
# Checking if the "conda activate hadrex" line is already in the .bashrc (should not add it twice!)
ENV_NAME=$(grep -E "^name:" install/packages_Linux.yaml | awk '{print $2}')

if ! grep -Fxq "conda activate ${ENV_NAME}" "$HOME/.bashrc"; then
  echo "conda activate ${ENV_NAME}" >> "$HOME/.bashrc"
fi

echo "Installation complete! Open a new terminal or run:"
echo "   conda activate ${ENV_NAME}"
echo "Thank you for waiting, and happy coding!"
echo "(If you do not want to open the HadrEx environment automatically on each new terminal session, remove the \"conda activate ${ENV_NAME}\" line from \"$HOME/.bashrc\")"

#!/bin/bash

# file: install.sh
# author: Kumarjit Das
# date: 2024-06-20
# brief: Install script file for project builds.
#
#
# LICENSE:
# 
# Copyright (c) 2024, Kumarjit Das
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# - Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


KDAPI_CLR_ERR="\e[31m"
KDAPI_CLR_INFO="\e[36m"
KDAPI_CLR_WARN="\e[33m"
KDAPI_CLR_RESET="\e[0m"

_KDAPI_GOTO_ENVIRONMENT_INFO=false
_KDAPI_GOTO_ENTRY=true
_KDAPI_GOTO_COMPLETE=false
_KDAPI_GOTO_ERROR_EXIT=false

function _KDAPI_ENVIRONMENT_INFO {
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} -------------------------------------------------------------------------"
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Make sure to set these environment variables before running this script."
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} You can create an environment setup script for this. By default this install"
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} script will search for 'setup_env.sh'."
  echo
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} These are the environment variables:"
  echo -e "\t- KDAPI_SETUP_ENV_FILE (optional) (default: setup_env.sh)"
  echo -e "\t- KDAPI_INSTALL_LOCATION (optional) (default: $(pwd))"
  echo -e "\t- KDAPI_INSTALL_NAME"
  echo -e "\t- KDAPI_INSTALL_VERSION"
  echo -e "\t- KDAPI_INSTALL_INCLUDE_FILES"
  _KDAPI_ERROR_EXIT
}

function _KDAPI_ERROR_EXIT {
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} Error(s) occurred. Could not finish installing."
  exit 1
}

function _KDAPI_COMPLETE {
  echo "[INSTALL] Finished installing."
  exit 0
}

echo "[INSTALL] Initializing install..."

# Set the environment
: ${KDAPI_SETUP_ENV_FILE:=setup_env.sh}

if [ -f "$KDAPI_SETUP_ENV_FILE" ]; then
  echo "[INSTALL] Setup file found ($KDAPI_SETUP_ENV_FILE)"
  echo "[INSTALL] Setting up install environment..."
  echo "[INSTALL] ----------------------------------------------------------------------"
  source "$KDAPI_SETUP_ENV_FILE"
  echo "[INSTALL] ----------------------------------------------------------------------"
  echo "[INSTALL] Install environment setup completed."
else
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} Setup environment file ($KDAPI_SETUP_ENV_FILE) does not exist."
  echo "[INSTALL] Install environment setup not done. Continuing..."
fi

# Check KDAPI_INSTALL_LOCATION
: ${KDAPI_INSTALL_LOCATION:=$(pwd)}

if [ ! -d "$KDAPI_INSTALL_LOCATION" ]; then
  echo "[INSTALL] Provided location/directory ($KDAPI_INSTALL_LOCATION) does not exist."
  _KDAPI_ENVIRONMENT_INFO
fi

echo "[INSTALL] Install location: $KDAPI_INSTALL_LOCATION"

# Check KDAPI_INSTALL_NAME
if [ -z "$KDAPI_INSTALL_NAME" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_INSTALL_NAME is not set."
  _KDAPI_ENVIRONMENT_INFO
fi

echo "[INSTALL] Install directory name: $KDAPI_INSTALL_NAME"

# Check KDAPI_INSTALL_VERSION
if [ -z "$KDAPI_INSTALL_VERSION" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_INSTALL_VERSION is not set."
  _KDAPI_ENVIRONMENT_INFO
fi

echo "[INSTALL] Install version: $KDAPI_INSTALL_VERSION"

# Check KDAPI_INSTALL_INCLUDE_FILES
if [ -z "$KDAPI_INSTALL_INCLUDE_FILES" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_INSTALL_INCLUDE_FILES is not set."
  _KDAPI_ENVIRONMENT_INFO
fi

echo "[INSTALL] Include files: $KDAPI_INSTALL_INCLUDE_FILES"

echo "[INSTALL] Started installing..."

# Create the install directory
KDAPI_INSTALL_DIR="$KDAPI_INSTALL_LOCATION/$KDAPI_INSTALL_NAME-$KDAPI_INSTALL_VERSION"
mkdir -p "$KDAPI_INSTALL_DIR"
echo "[INSTALL] Created install directory ($KDAPI_INSTALL_DIR)."

# Copy include files
KDAPI_TMP_ERR=false

for f in $KDAPI_INSTALL_INCLUDE_FILES; do
  if [ -f "$f" ]; then
    cp "$f" "$KDAPI_INSTALL_DIR/"
    echo "[INSTALL] Copied $f to $KDAPI_INSTALL_DIR"
  else
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} File ($f) does not exist."
    KDAPI_TMP_ERR=true
  fi
done

if [ "$KDAPI_TMP_ERR" = true ]; then
  _KDAPI_ERROR_EXIT
fi

echo "[INSTALL] Copied all include files."

# Copy license, readme, and release-notes files
KDAPI_TMP_ERR=false

KDAPI_INSTALL_OTHER_FILES=("LICENSE.txt" "README.md" "Release Notes.md")
for f in "${KDAPI_INSTALL_OTHER_FILES[@]}"; do
  if [ -f "$f" ]; then
    cp "$f" "$KDAPI_INSTALL_DIR/"
    echo "[INSTALL] Copied $f to $KDAPI_INSTALL_DIR"
  else
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} File ($f) does not exist."
  fi
done

if [ "$KDAPI_TMP_ERR" = true ]; then
  _KDAPI_ERROR_EXIT
fi

echo "[INSTALL] Copied license, readme, and release-notes files."

_KDAPI_COMPLETE

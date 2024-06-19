#!/bin/bash

# file: clean.sh
# author: Kumarjit Das
# date: 2024-06-20
# brief: Clean script file for project builds.
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


clean_all() {
  if [ -d "$KDAPI_BUILD_DIR" ]; then
    echo "[CLEAN] Removing the entire build directory..."
    rm -rf "$KDAPI_BUILD_DIR"
    echo "[CLEAN] All the contents of '$KDAPI_BUILD_DIR' directory including itself have been deleted."
  else
    echo "[CLEAN] '$KDAPI_BUILD_DIR' does not exist."
    nothing_to_clean
  fi
  
  complete
}

nothing_to_clean() {
  echo "[CLEAN] Nothing to clean."
  exit 0
}

complete() {
  echo "[CLEAN] Cleaning completed."
  exit 0
}

echo "[CLEAN] Cleaning up builds..."

# Build directories
KDAPI_BUILD_DIR=build
KDAPI_LIB_DIR="$KDAPI_BUILD_DIR/lib"
KDAPI_BIN_DIR="$KDAPI_BUILD_DIR/bin"

if [ "$1" == "all" ]; then
  clean_all
fi

if [ ! -d "$KDAPI_LIB_DIR" ] && [ ! -d "$KDAPI_BIN_DIR" ]; then
  nothing_to_clean
fi

# Clean the lib directory
if [ -d "$KDAPI_LIB_DIR" ]; then
  echo "[CLEAN] Removing contents of '$KDAPI_LIB_DIR'..."
  rm -rf "$KDAPI_LIB_DIR"/*
  echo "[CLEAN] All the contents of '$KDAPI_LIB_DIR' have been removed."
else
  echo "[CLEAN] '$KDAPI_LIB_DIR' does not exist."
fi

# Clean the bin directory
if [ -d "$KDAPI_BIN_DIR" ]; then
  echo "[CLEAN] Removing contents of '$KDAPI_BIN_DIR'..."
  rm -rf "$KDAPI_BIN_DIR"/*
  echo "[CLEAN] All the contents of '$KDAPI_BIN_DIR' have been deleted."
else
  echo "[CLEAN] '$KDAPI_BIN_DIR' does not exist."
fi

complete

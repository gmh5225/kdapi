#!/bin/bash

# file: setup_env.template.sh
# author: Kumarjit Das
# date: 2024-06-20
# brief: A template for build environment setup.
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


# Build specific
echo "Setting build specific variables..."

# KDAPI_HOST_ARCH="x86"
KDAPI_HOST_ARCH="x64"
echo "Host architecture set to '$KDAPI_HOST_ARCH'"

# KDAPI_TARGET_ARCH="X86"
KDAPI_TARGET_ARCH="x64"
echo "Target architecture set to '$KDAPI_TARGET_ARCH'"

KDAPI_COMPILER_PROVIDER="gnu"
# KDAPI_COMPILER_PROVIDER="llvm"
echo "Compiler provider set to '$KDAPI_COMPILER_PROVIDER'"

# KDAPI_BUILD_TOOLS_PATH="/usr/bin"
# echo "Build tools path set to '$KDAPI_BUILD_TOOLS_PATH'"

# KDAPI_COMPILER_NAME="gcc"
# KDAPI_COMPILER_NAME="clang"
# echo "Compiler name set to '$KDAPI_COMPILER_NAME'"

# KDAPI_LINKER_NAME="ld"
# KDAPI_LINKER_NAME="gcc"
# KDAPI_LINKER_NAME="clang"
# echo "Linker name set to '$KDAPI_LINKER_NAME'"

KDAPI_COMPILER_OPTIMIZE=true
# KDAPI_COMPILER_OPTIMIZE=false
echo "Compiler optimization set to '$KDAPI_COMPILER_OPTIMIZE'"

# KDAPI_BUILD_TYPE="release"
KDAPI_BUILD_TYPE="debug"
echo "Build type set to '$KDAPI_BUILD_TYPE'"

# Installation specific
echo "Setting install specific variables..."

KDAPI_INSTALL_LOCATION="$HOME"
echo "Install location set to '$KDAPI_INSTALL_LOCATION'"

KDAPI_INSTALL_NAME="kdapi"
echo "Install name set to '$KDAPI_INSTALL_NAME'"

KDAPI_INSTALL_VERSION="1.1.0"
echo "Install version set to '$KDAPI_INSTALL_VERSION'"

KDAPI_INSTALL_INCLUDE_FILES="kdapi.h"
echo "Include files are $KDAPI_INSTALL_INCLUDE_FILES"

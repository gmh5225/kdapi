#$/bin/bash

# file: build.sh
# author: Kumarjit Das
# date: 2024-06-20
# brief: Build script file for project.
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

KDAPI_CLEAN_FILE="clean.sh"
KDAPI_INSTALL_FILE="install.sh"
KDAPI_KNOWN_ARGS=("clean" "clean-all" "run" "install")
KDAPI_HOST_ARCH_LIST=("x86" "x64")
KDAPI_TARGET_KDAPI_ARCH_LIST=("x86" "x64")
KDAPI_COMPILER_PROVIDER_LIST=("gnu" "llvm")
KDAPI_BUILD_TYPE_LIST=("debug" "release")
KDAPI_SOURCE_DIR="."
KDAPI_INCLUDE_DIR="."
KDAPI_SOURCE_FILES=("test.c")
KDAPI_OUTPUT_NAME="test"

# Print environment information
_KDAPI_ENVIRONMENT_INFO() {
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} -------------------------------------------------------------------------"
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Make sure to set these environment variables before running this script."
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} You can create an environment setup script for this. By default, this build"
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} script will search for 'setup_env.sh'."
  echo
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} These are the environment variables:"

  echo -e "\t - KDAPI_SETUP_ENV_FILE (optional) (default: setup_env.sh)"

  echo -e "\t - KDAPI_HOST_ARCH"
  echo -e "\t\tValid values:"
  echo -e "\t\t\t${KDAPI_HOST_ARCH_LIST[@]}"

  echo -e "\t - KDAPI_TARGET_ARCH"
  echo -e "\t\tValid values:"
  echo -e "\t\t\t${KDAPI_TARGET_KDAPI_ARCH_LIST[@]}"

  echo -e "\t - KDAPI_COMPILER_PROVIDER"
  echo -e "\t\tValid values:"
  echo -e "\t\t\t${KDAPI_COMPILER_PROVIDER_LIST[@]}"

  echo -e "\t - KDAPI_BUILD_TOOLS_PATH (optional) (i.e. /usr/bin)"
  echo -e "\t - KDAPI_COMPILER_NAME (optional) (i.e. gcc, clang)"
  echo -e "\t - KDAPI_LINKER_NAME (optional) (i.e. ld, clang-ld)"

  echo -e "\t - KDAPI_COMPILER_OPTIMIZE"
  echo -e "\t\tValid values:"
  echo -e "\t\t\ttrue false"

  echo -e "\t - KDAPI_BUILD_TYPE"
  echo -e "\t\tValid values:"
  echo -e "\t\t\t${KDAPI_BUILD_TYPE_LIST[@]}"

  _KDAPI_ERROR_EXIT
}

_KDAPI_ERROR_EXIT() {
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} Error(s) occurred. Could not finish building."
  exit 1
}

_KDAPI_COMPLETE() {
  echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Finished building."
  
  if [ "$KDAPI_RUN_TEST_CMD" == "true" ]; then
    echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Running the test executable..."
    echo -e "[CMD] $KDAPI_BIN_DIR/$KDAPI_EXEC_FILE"
    echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} ------------------------------------------------------------------------"
    echo
    
    $KDAPI_BIN_DIR/$KDAPI_EXEC_FILE
    
    echo
    echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} ------------------------------------------------------------------------"
    
    if [ $? -eq 0 ]; then
      echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Finished running."
    else
      echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} Error(s) occurred while running the executable."
    fi
  else
    echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} To run use command: \`$KDAPI_BIN_DIR/$KDAPI_EXEC_FILE\`"
  fi
  
  if [ "$KDAPI_RUN_INSTALL_CMD" == "true" ]; then
    if [ -f "$KDAPI_INSTALL_FILE" ]; then
      echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Installing project..."
      echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} ------------------------------------------------------------------------"
      source $KDAPI_INSTALL_FILE
      echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} ------------------------------------------------------------------------"
      echo -e "${KDAPI_CLR_INFO}[INFO]${KDAPI_CLR_RESET} Project installed."
    fi
  fi
  
  exit 0
}

_KDAPI_ARCH_32BIT_BUILD() {
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    KDAPI_TARGET_ARCH_FLAG=-m32
    _KDAPI_GNU_BUILD
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    KDAPI_TARGET_ARCH_FLAG="--target=i686-pc-linux-gnu"
    _KDAPI_LLVM_BUILD
  fi
  _KDAPI_COMPLETE
}

_KDAPI_ARCH_64BIT_BUILD() {
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    KDAPI_TARGET_ARCH_FLAG=-m64
    _KDAPI_GNU_BUILD
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    KDAPI_TARGET_ARCH_FLAG="--target=x86_64-pc-linux-gnu"
    _KDAPI_LLVM_BUILD
  fi
  _KDAPI_COMPLETE
}

_KDAPI_GNU_BUILD() {
  echo -e "[BUILD] Compiling source files..."
  KDAPI_OBJECT_FILES=""

  for i in ${KDAPI_SOURCE_FILES[@]}; do
    echo -e "[BUILD] Compiling '$i'..."
    
    KDAPI_TMP_CMD="$KDAPI_COMPILER -std=iso9899:1990 $KDAPI_COMPILER_OPTIMIZE_FLAGS $KDAPI_TARGET_ARCH_FLAG $KDAPI_DEBUG_FLAG $KDAPI_WARNING_FLAG -c $KDAPI_SOURCE_DIR/$i -I$KDAPI_INCLUDE_DIR -o $KDAPI_BIN_DIR/${i%.*}$KDAPI_BUILD_POSTFIX.$KDAPI_OBJECT_FILE_EXT"
    
    echo -e "[CMD] $KDAPI_TMP_CMD"
    $KDAPI_TMP_CMD
    
    KDAPI_OBJECT_FILES="$KDAPI_OBJECT_FILES $KDAPI_BIN_DIR/${i%.*}$KDAPI_BUILD_POSTFIX.$KDAPI_OBJECT_FILE_EXT"
  done

  echo -e "[BUILD] Linking object files..."
  KDAPI_TMP_CMD="$KDAPI_LINKER $KDAPI_TARGET_ARCH_FLAG $KDAPI_DEBUG_FLAG $KDAPI_OBJECT_FILES -o $KDAPI_BIN_DIR/$KDAPI_EXEC_FILE"
  echo -e "[CMD] $KDAPI_TMP_CMD"
  $KDAPI_TMP_CMD

  _KDAPI_COMPLETE
}

_KDAPI_LLVM_BUILD() {
  echo -e "[BUILD] Compiling source files..."
  KDAPI_OBJECT_FILES=""

  for i in ${KDAPI_SOURCE_FILES[@]}; do
    echo -e "[BUILD] Compiling '$i'..."
    
    KDAPI_TMP_CMD="$KDAPI_COMPILER -std=c89 $KDAPI_COMPILER_OPTIMIZE_FLAGS $KDAPI_TARGET_ARCH_FLAG $KDAPI_DEBUG_FLAG $KDAPI_WARNING_FLAG -c $KDAPI_SOURCE_DIR/$i -I$KDAPI_INCLUDE_DIR -o $KDAPI_BIN_DIR/${i%.*}$KDAPI_BUILD_POSTFIX.$KDAPI_OBJECT_FILE_EXT"
    
    echo -e "[CMD] $KDAPI_TMP_CMD"
    $KDAPI_TMP_CMD
    
    KDAPI_OBJECT_FILES="$KDAPI_OBJECT_FILES $KDAPI_BIN_DIR/${i%.*}$KDAPI_BUILD_POSTFIX.$KDAPI_OBJECT_FILE_EXT"
  done

  echo -e "[BUILD] Building executable..."
  KDAPI_TMP_CMD="$KDAPI_LINKER $KDAPI_TARGET_ARCH_FLAG $KDAPI_DEBUG_FLAG $KDAPI_OBJECT_FILES -o $KDAPI_BIN_DIR/$KDAPI_EXEC_FILE"
  echo -e "[CMD] $KDAPI_TMP_CMD"
  $KDAPI_TMP_CMD

  _KDAPI_COMPLETE
}

echo -e "[BUILD] Initializing build..."

# Check arguments
KDAPI_UNKNOWN_ARGS_FIRST_SET=false
KDAPI_UNKNOWN_ARGS=()

KDAPI_RUN_CLEAN_CMD=false
KDAPI_RUN_CLEAN_ALL_CMD=false
KDAPI_RUN_TEST_CMD=false
KDAPI_RUN_INSTALL_CMD=false

for arg in "$@"; do
  _KDAPI_FOUND=false

  for known_arg in "${KDAPI_KNOWN_ARGS[@]}"; do
    if [ "$known_arg" == "$arg" ]; then
      _KDAPI_FOUND=true
      break
    fi
  done

  if [ "$_KDAPI_FOUND" == false ]; then
    KDAPI_UNKNOWN_ARGS+=("$arg")
  fi
done

if [ ${#KDAPI_UNKNOWN_ARGS[@]} -ne 0 ]; then
  echo -e "${KDAPI_CLR_WARN}[WARN]${KDAPI_CLR_RESET} Unknown arguments (ignored): ${KDAPI_UNKNOWN_ARGS[@]}"
fi

for arg in "$@"; do
  if [ "$arg" == "clean" ]; then
    KDAPI_RUN_CLEAN_CMD=true
  elif [ "$arg" == "clean-all" ]; then
    KDAPI_RUN_CLEAN_CMD=true
    KDAPI_RUN_CLEAN_ALL_CMD=true
  elif [ "$arg" == "run" ]; then
    KDAPI_RUN_TEST_CMD=true
  elif [ "$arg" == "install" ]; then
    KDAPI_RUN_INSTALL_CMD=true
  fi
done

# Clean up previous builds
if [ "$KDAPI_RUN_CLEAN_CMD" == true ]; then
  if [ -e "$KDAPI_CLEAN_FILE" ]; then
    _KDAPI_ARG=""
    
    if [ "$KDAPI_RUN_CLEAN_ALL_CMD" == true ]; then
      _KDAPI_ARG="all"
    fi

    echo -e "[BUILD] Cleaning up previous builds..."
    echo -e "[BUILD] ------------------------------------------------------------------------"

    bash $KDAPI_CLEAN_FILE $_KDAPI_ARG

    echo -e "[BUILD] ------------------------------------------------------------------------"
    echo -e "[BUILD] Previous builds cleaned."
  fi
fi

# Set the environment
if [ -z "${KDAPI_SETUP_ENV_FILE}" ]; then
  KDAPI_SETUP_ENV_FILE="setup_env.sh"
fi

if [ -e "$KDAPI_SETUP_ENV_FILE" ]; then
  echo -e "[BUILD] Setup file found ($KDAPI_SETUP_ENV_FILE)"
  echo -e "[BUILD] Setting up build environment..."
  echo -e "[BUILD] ------------------------------------------------------------------------"
  source $KDAPI_SETUP_ENV_FILE
  echo -e "[BUILD] ------------------------------------------------------------------------"
  echo -e "[BUILD] Build environment setup completed."
else
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} Setup environment file ($KDAPI_SETUP_ENV_FILE) does not exist."
  echo -e "[BUILD] Build environment setup not done. Continuing..."
fi

# Check KDAPI_HOST_ARCH
if [ -z "${KDAPI_HOST_ARCH}" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_HOST_ARCH is not set."
  _KDAPI_ENVIRONMENT_INFO
else
  KDAPI_HOST_ARCH_FOUND=false

  for arch in "${KDAPI_HOST_ARCH_LIST[@]}"; do
    if [ "$arch" == "$KDAPI_HOST_ARCH" ]; then
      KDAPI_HOST_ARCH_FOUND=true
      break
    fi
  done

  if [ "$KDAPI_HOST_ARCH_FOUND" == true ]; then
    echo -e "[BUILD] Host architecture: $KDAPI_HOST_ARCH"
  else
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} The provided architecture is not supported by this build script (KDAPI_HOST_ARCH=\"$KDAPI_HOST_ARCH\")."
    _KDAPI_ENVIRONMENT_INFO
  fi
fi

# Check KDAPI_TARGET_ARCH
if [ -z "${KDAPI_TARGET_ARCH}" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_TARGET_ARCH is not set."
  _KDAPI_ENVIRONMENT_INFO
else
  KDAPI_TARGET_KDAPI_ARCH_FOUND=false

  for arch in "${KDAPI_TARGET_KDAPI_ARCH_LIST[@]}"; do
    if [ "$arch" == "$KDAPI_TARGET_ARCH" ]; then
      KDAPI_TARGET_KDAPI_ARCH_FOUND=true
      break
    fi
  done

  if [ "$KDAPI_TARGET_KDAPI_ARCH_FOUND" == true ]; then
    echo -e "[BUILD] Target architecture: $KDAPI_TARGET_ARCH"
  else
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} The provided architecture is not supported by this build script (KDAPI_TARGET_ARCH=\"$KDAPI_TARGET_ARCH\")."
    _KDAPI_ENVIRONMENT_INFO
  fi
fi

# Check KDAPI_COMPILER_PROVIDER
if [ -z "${KDAPI_COMPILER_PROVIDER}" ]; then
  echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} KDAPI_COMPILER_PROVIDER is not set."
  _KDAPI_ENVIRONMENT_INFO
else
  KDAPI_COMPILER_PROVIDER_FOUND=false

  for provider in "${KDAPI_COMPILER_PROVIDER_LIST[@]}"; do
    if [ "$provider" == "$KDAPI_COMPILER_PROVIDER" ]; then
      KDAPI_COMPILER_PROVIDER_FOUND=true
      break
    fi
  done

  if [ "$KDAPI_COMPILER_PROVIDER_FOUND" == true ]; then
    echo -e "[BUILD] Compiler provider: $KDAPI_COMPILER_PROVIDER"
  else
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} The provided compiler is not supported by this build script (KDAPI_COMPILER_PROVIDER=\"$KDAPI_COMPILER_PROVIDER\")."
    _KDAPI_ENVIRONMENT_INFO
  fi
fi

# Check if cross-compiling
if [ "$KDAPI_HOST_ARCH" != "$KDAPI_TARGET_ARCH" ]; then
  KDAPI_CROSS_COMPILING=true
  echo -e "[BUILD] Compilation type: CROSS_COMPILING"
else
  KDAPI_CROSS_COMPILING=false
  echo -e "[BUILD] Compilation type: NATIVE"
fi

# Check KDAPI_BUILD_TOOLS_PATH
if [ -z "${KDAPI_BUILD_TOOLS_PATH}" ]; then
  echo -e "${KDAPI_CLR_WARN}[WARNING]${KDAPI_CLR_RESET} Build tools path (KDAPI_BUILD_TOOLS_PATH) is not provided. Assuming build tools are globally available."
fi

# Check KDAPI_COMPILER_NAME
if [ -n "$KDAPI_COMPILER_NAME" ]; then
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    echo -e "[BUILD] '$KDAPI_COMPILER_NAME' will be used as compiler instead of 'gcc'"
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    echo -e "[BUILD] '$KDAPI_COMPILER_NAME' will be used as compiler instead of 'clang'"
  fi
else
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    KDAPI_COMPILER_NAME="gcc"
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    KDAPI_COMPILER_NAME="clang"
  fi
fi

KDAPI_COMPILER=$KDAPI_COMPILER_NAME
echo -e "[BUILD] Compiler: $KDAPI_COMPILER"

# Check KDAPI_LINKER_NAME
if [ -n "$KDAPI_LINKER_NAME" ]; then
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    echo -e "[BUILD] '$KDAPI_LINKER_NAME' will be used as linker instead of 'gcc'"
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    echo -e "[BUILD] '$KDAPI_LINKER_NAME' will be used as linker instead of 'clang'"
  fi
else
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    KDAPI_LINKER_NAME="gcc"
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    KDAPI_LINKER_NAME="clang"
  fi
fi

KDAPI_LINKER=$KDAPI_LINKER_NAME
echo -e "[BUILD] Linker: $KDAPI_LINKER"

# Check KDAPI_BUILD_TYPE
if [ -z "$KDAPI_BUILD_TYPE" ]; then
  KDAPI_BUILD_TYPE="release"
else
  KDAPI_BUILD_TYPE_FOUND=false

  for i in "${KDAPI_BUILD_TYPE_LIST[@]}"; do
    if [ "$i" == "$KDAPI_BUILD_TYPE" ]; then
      KDAPI_BUILD_TYPE_FOUND=true
      break
    fi
  done

  if ! $KDAPI_BUILD_TYPE_FOUND; then
    echo -e "${KDAPI_CLR_ERR}[ERROR]${KDAPI_CLR_RESET} The provided build type is not supported by this build script (KDAPI_BUILD_TYPE=\"$KDAPI_BUILD_TYPE\")."
    _KDAPI_ENVIRONMENT_INFO
  fi
fi

# Print the build type
echo -e "[BUILD] Build type: $KDAPI_BUILD_TYPE"

# Output postfixes
KDAPI_BUILD_POSTFIX=""

if [ "$KDAPI_BUILD_TYPE" == "debug" ]; then
  KDAPI_BUILD_POSTFIX="-d"
fi

# Debugger flag
KDAPI_DEBUG_FLAG=""

if [ "$KDAPI_BUILD_TYPE" == "debug" ]; then
  if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
    KDAPI_DEBUG_FLAG="-ggdb"
  elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
    KDAPI_DEBUG_FLAG="-g"
  fi
fi

# Optimize flag
KDAPI_COMPILER_OPTIMIZE_FLAGS=""

if [ "$KDAPI_COMPILER_OPTIMIZE" == "true" ] && [ "$KDAPI_BUILD_TYPE" == "release" ]; then
  KDAPI_COMPILER_OPTIMIZE_FLAGS="-O2"
fi

# Warnings flag
KDAPI_WARNING_FLAG=""

if [ "$KDAPI_COMPILER_PROVIDER" == "gnu" ]; then
  KDAPI_WARNING_FLAG="-Wall -Werror -Wextra -pedantic"
elif [ "$KDAPI_COMPILER_PROVIDER" == "llvm" ]; then
  KDAPI_WARNING_FLAG="-Wall -Werror -Wextra -Wpedantic"
fi

# Output binaries
KDAPI_EXEC_FILE="$KDAPI_OUTPUT_NAME$KDAPI_BUILD_POSTFIX"
KDAPI_OBJECT_FILE_EXT="o"

echo -e "[BUILD] Started building..."

# Output directories
KDAPI_BUILD_DIR=build
KDAPI_BIN_DIR="$KDAPI_BUILD_DIR/bin"

if [ ! -d "$KDAPI_BUILD_DIR" ]; then
  mkdir -p "$KDAPI_BUILD_DIR"
  echo -e "[BUILD] Created directory: $KDAPI_BUILD_DIR"
fi

if [ ! -d "$KDAPI_BIN_DIR" ]; then
  mkdir -p "$KDAPI_BIN_DIR"
  echo -e "[BUILD] Created directory: $KDAPI_BIN_DIR"
fi

if [ "$KDAPI_CROSS_COMPILING" == "true" ]; then
  if [ "$KDAPI_HOST_ARCH" == "x86" ]; then
    KDAPI_BIN_DIR="$KDAPI_BIN_DIR/x86_x64"
  elif [ "$KDAPI_HOST_ARCH" == "x64" ]; then
    KDAPI_BIN_DIR="$KDAPI_BIN_DIR/x64_x86"
  fi
else
  if [ "$KDAPI_TARGET_ARCH" == "x86" ]; then
    KDAPI_BIN_DIR="$KDAPI_BIN_DIR/x86"
  elif [ "$KDAPI_TARGET_ARCH" == "x64" ]; then
    KDAPI_BIN_DIR="$KDAPI_BIN_DIR/x64"
  fi
fi

if [ ! -d "$KDAPI_BIN_DIR" ]; then
  mkdir -p "$KDAPI_BIN_DIR"
  echo -e "[BUILD] Created directory: $KDAPI_BIN_DIR"
fi

if [ "$KDAPI_BUILD_TYPE" == "debug" ]; then
  KDAPI_BIN_DIR="$KDAPI_BIN_DIR/debug"
elif [ "$KDAPI_BUILD_TYPE" == "release" ]; then
  KDAPI_BIN_DIR="$KDAPI_BIN_DIR/release"
fi

if [ ! -d "$KDAPI_BIN_DIR" ]; then
  mkdir -p "$KDAPI_BIN_DIR"
  echo -e "[BUILD] Created directory: $KDAPI_BIN_DIR"
fi

# Main build process
if [ "$KDAPI_TARGET_ARCH" == "x86" ]; then
  _KDAPI_ARCH_32BIT_BUILD
elif [ "$KDAPI_TARGET_ARCH" == "x64" ]; then
  _KDAPI_ARCH_64BIT_BUILD
fi

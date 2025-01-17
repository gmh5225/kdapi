@REM file: setup_env.template.bat
@REM author: Kumarjit Das
@REM date: 2024-06-20
@REM brief: A template for build environment setup.
@REM
@REM
@REM LICENSE:
@REM 
@REM Copyright (c) 2024, Kumarjit Das
@REM All rights reserved.
@REM 
@REM Redistribution and use in source and binary forms, with or without
@REM modification, are permitted provided that the following conditions are met:
@REM 
@REM - Redistributions of source code must retain the above copyright notice, this
@REM   list of conditions and the following disclaimer.
@REM 
@REM - Redistributions in binary form must reproduce the above copyright notice,
@REM   this list of conditions and the following disclaimer in the documentation
@REM   and/or other materials provided with the distribution.
@REM 
@REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
@REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
@REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
@REM DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
@REM FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
@REM DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
@REM SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
@REM CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
@REM OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
@REM OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

@REM Build specific
ECHO Setting build specific variables...

@REM SET KDAPI_HOST_ARCH=x86
SET KDAPI_HOST_ARCH=x64
ECHO Host architecture set to '%KDAPI_HOST_ARCH%'

@REM SET KDAPI_TARGET_ARCH=X86
SET KDAPI_TARGET_ARCH=x64
ECHO Target architecture set to '%KDAPI_TARGET_ARCH%'

@REM SET KDAPI_COMPILER_PROVIDER=mingw
@REM SET KDAPI_COMPILER_PROVIDER=llvm
SET KDAPI_COMPILER_PROVIDER=msvc
ECHO Compiler provider set to '%KDAPI_COMPILER_PROVIDER%'

@REM "SET KDAPI_BUILD_TOOLS_PATH=C:\mingw32\bin"
@REM "SET KDAPI_BUILD_TOOLS_PATH=C:\mingw64\bin"
@REM "SET KDAPI_BUILD_TOOLS_PATH=C:\llvm\bin"
SET "KDAPI_BUILD_TOOLS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
ECHO Build tools path set to '%KDAPI_BUILD_TOOLS_PATH%'

@REM SET KDAPI_COMPILER_NAME=gcc.exe
@REM SET KDAPI_COMPILER_NAME=clang.exe
@REM SET KDAPI_COMPILER_NAME=cl.exe
@REM ECHO Compiler name set to '%KDAPI_COMPILER_NAME%'

@REM SET KDAPI_LINKER_NAME=ld.exe
@REM SET KDAPI_LINKER_NAME=clang-ld.exe
@REM SET KDAPI_LINKER_NAME=link.exe
@REM ECHO Linker name set to '%KDAPI_LINKER_NAME%'

SET KDAPI_COMPILER_OPTIMIZE=true
@REM SET KDAPI_COMPILER_OPTIMIZE=false
ECHO Compiler optimization set to '%KDAPI_COMPILER_OPTIMIZE%'

@REM SET KDAPI_BUILD_TYPE=release
SET KDAPI_BUILD_TYPE=debug
ECHO Build type set to '%KDAPI_BUILD_TYPE%'

@REM Installation specific
ECHO Setting install specific variables...

SET "KDAPI_INSTALL_LOCATION=C:\Program Files"
ECHO Install location set to '%KDAPI_INSTALL_LOCATION%'

SET KDAPI_INSTALL_NAME=kdapi
ECHO Install name set to '%KDAPI_INSTALL_NAME%'

SET KDAPI_INSTALL_VERSION=1.1.0
ECHO Install version set to '%KDAPI_INSTALL_VERSION%'

SET "KDAPI_INSTALL_INCLUDE_FILES=kdapi.h"
ECHO Include files are %KDAPI_INSTALL_INCLUDE_FILES%

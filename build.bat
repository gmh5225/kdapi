@REM file: build.bat
@REM author: Kumarjit Das
@REM date: 2024-06-02
@REM brief: Build script file for project.
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


SET "TAB=	"
SET KDAPI_CLEAN_FILE=clean.bat
SET KDAPI_INSTALL_FILE=install.bat
SET "KDAPI_KNOWN_ARGS=clean clean-all run install"
SET "KDAPI_HOST_ARCH_LIST=x86 x64"
SET "KDAPI_TARGET_KDAPI_ARCH_LIST=x86 x64"
SET "KDAPI_COMPILER_PROVIDER_LIST=mingw llvm msvc"
SET "KDAPI_BUILD_TYPE_LIST=debug release"
SET KDAPI_SOURCE_DIR=.
SET KDAPI_INCLUDE_DIR=.
SET KDAPI_OUTPUT_NAME=test


GOTO :KDAPI_START_BUILDING


@REM Print environment information
:_KDAPI_ENVIRONMENT_INFO
  ECHO --------------------------------------------------------------------------------
  ECHO Make sure to set these environment variables before running this script.
  ECHO You can create an environment setup batch file for this. By default this build
  ECHO script will search for 'setup_env.bat'.
  ECHO.
  ECHO These are the environment variables:

  ECHO %TAB%- KDAPI_SETUP_ENV_FILE ^(optional^) ^(default: setup_env.bat^)

  ECHO %TAB%- KDAPI_HOST_ARCH
  ECHO %TAB% %TAB%Valid values:
  ECHO %TAB% %TAB% %TAB% %KDAPI_HOST_ARCH_LIST%

  ECHO %TAB%- KDAPI_TARGET_ARCH
  ECHO %TAB% %TAB%Valid values:
  ECHO %TAB% %TAB% %TAB% %KDAPI_TARGET_KDAPI_ARCH_LIST%

  ECHO %TAB%- KDAPI_COMPILER_PROVIDER
  ECHO %TAB% %TAB% Valid values:
  ECHO %TAB% %TAB% %TAB% %KDAPI_COMPILER_PROVIDER_LIST%

  ECHO %TAB%- KDAPI_BUILD_TOOLS_PATH ^(optional^) ^(i.e. C:\Users\^<username^>\mingw64\bin^)
  ECHO %TAB%- KDAPI_COMPILER_NAME ^(optional^) ^(i.e. gcc.exe, clang.exe^)

  ECHO %TAB%- KDAPI_BUILD_TYPE
  ECHO %TAB% %TAB% Valid values:
  ECHO %TAB% %TAB% %TAB% %KDAPI_BUILD_TYPE_LIST%

  GOTO :_KDAPI_ERROR_EXIT


:KDAPI_START_BUILDING
ECHO [BUILD] Initializing build...


@REM Check arguments
SET KDAPI_UNKNOWN_ARGS_FIRST_SET=false

SET KDAPI_RUN_CLEAN_CMD=false
SET KDAPI_RUN_CLEAN_ALL_CMD=false
SET KDAPI_RUN_TEST_CMD=false
SET KDAPI_RUN_INSTALL_CMD=false

FOR %%i IN (%*) DO (
  set _KDAPI_FOUND=false
  
  FOR %%j IN (%KDAPI_KNOWN_ARGS%) DO (
    IF "%%i"=="%%j" (
      SET _KDAPI_FOUND=true
      GOTO :_KDAPI_NEXT_ARG
    )
  )

  :_KDAPI_NEXT_ARG
  IF "%_KDAPI_FOUND%"=="false" (
    IF "%KDAPI_UNKNOWN_ARGS_FIRST_SET%"=="true" (
      SET "KDAPI_UNKNOWN_ARGS=!KDAPI_UNKNOWN_ARGS! %%i"
    ) ELSE (
      SET KDAPI_UNKNOWN_ARGS_FIRST_SET=true
      SET "KDAPI_UNKNOWN_ARGS=%%i"
    )
  )
)

IF DEFINED KDAPI_UNKNOWN_ARGS (
  ECHO [INFO] Unknown arguments ^(ignored^)^: %KDAPI_UNKNOWN_ARGS%
)

FOR %%i IN (%*) DO (
  IF "%%i"=="clean" (
    SET KDAPI_RUN_CLEAN_CMD=true
  ) ELSE IF "%%i"=="clean-all" (
    SET KDAPI_RUN_CLEAN_CMD=true
    SET KDAPI_RUN_CLEAN_ALL_CMD=true
  ) ELSE IF "%%i"=="run" (
    SET KDAPI_RUN_TEST_CMD=true
  ) ELSE IF "%%i"=="install" (
    SET KDAPI_RUN_INSTALL_CMD=true
  )
)


@REM Clean up previous builds
IF "%KDAPI_RUN_CLEAN_CMD%"=="true" (
  IF EXIST "%KDAPI_CLEAN_FILE%" (
    SET _KDAPI_ARG=
    
    IF "%KDAPI_RUN_CLEAN_ALL_CMD%"=="true" (
      SET _KDAPI_ARG="all"
    )

    ECHO [BUILD] Cleaning up previous builds...
    ECHO ---------------------------------------

    CALL %KDAPI_CLEAN_FILE% %_KDAPI_ARG%

    ECHO ---------------------------------------
    ECHO [BUILD] Previous builds cleaned.
  )
)


@REM Set the environment
IF NOT DEFINED KDAPI_SETUP_ENV_FILE (
  SET KDAPI_SETUP_ENV_FILE=setup_env.bat
)

IF EXIST "%KDAPI_SETUP_ENV_FILE%" (
  ECHO [BUILD] Setup file found ^(%KDAPI_SETUP_ENV_FILE%^)
  ECHO [BUILD] Setting up build environment...
  ECHO ---------------------------------------
  CALL %KDAPI_SETUP_ENV_FILE%
  ECHO ---------------------------------------
  ECHO [BUILD] Build environment setup completed.
) ELSE (
  ECHO [ERROR] Setup environment file ^(%KDAPI_SETUP_ENV_FILE%^) does not exist.
  ECHO [BUILD] Build environment setup not done. Continueing...
)


@REM Check KDAPI_HOST_ARCH
IF NOT DEFINED KDAPI_HOST_ARCH (
  ECHO [ERROR] `KDAPI_HOST_ARCH` is not set.
  GOTO :_KDAPI_ENVIRONMENT_INFO
) ELSE (
  FOR %%i IN (%KDAPI_HOST_ARCH_LIST%) DO (
    IF "%%i"=="%KDAPI_HOST_ARCH%" (
      GOTO :KDAPI_HOST_ARCH_FOUND
    )
  )

  ECHO [ERROR] The provided architecture is not supported by this build script ^(KDAPI_HOST_ARCH="%KDAPI_HOST_ARCH%"^).
  GOTO :_KDAPI_ENVIRONMENT_INFO
)

:KDAPI_HOST_ARCH_FOUND
ECHO [BUILD] Host architecture: %KDAPI_HOST_ARCH%


@REM Check KDAPI_TARGET_ARCH
IF NOT DEFINED KDAPI_TARGET_ARCH (
  ECHO [ERROR] `KDAPI_TARGET_ARCH` is not set.
  GOTO :_KDAPI_ENVIRONMENT_INFO
) ELSE (
  FOR %%i IN (%KDAPI_TARGET_KDAPI_ARCH_LIST%) DO (
    IF "%%i"=="%KDAPI_TARGET_ARCH%" (
      GOTO :_KDAPI_TARGET_KDAPI_ARCH_FOUND
    )
  )

  ECHO [ERROR] The provided architecture is not supported by this build script ^(KDAPI_TARGET_ARCH="%KDAPI_TARGET_ARCH%"^).
  GOTO :_KDAPI_ENVIRONMENT_INFO
)

:_KDAPI_TARGET_KDAPI_ARCH_FOUND
ECHO [BUILD] Target architecture: %KDAPI_TARGET_ARCH%


@REM Check KDAPI_COMPILER_PROVIDER
IF NOT DEFINED KDAPI_COMPILER_PROVIDER (
  ECHO [ERROR] `KDAPI_COMPILER_PROVIDER` is not set.
  GOTO :_KDAPI_ENVIRONMENT_INFO
) ELSE (
  FOR %%i IN (%KDAPI_COMPILER_PROVIDER_LIST%) DO (
    IF "%%i"=="%KDAPI_COMPILER_PROVIDER%" (
      GOTO :_KDAPI_COMPILER_PROVIDER_FOUND
    )
  )

  ECHO [ERROR] The provided compiler is not supported by this build script ^(KDAPI_COMPILER_PROVIDER="%KDAPI_COMPILER_PROVIDER%"^).
  GOTO :_KDAPI_ENVIRONMENT_INFO
)

:_KDAPI_COMPILER_PROVIDER_FOUND
ECHO [BUILD] Compiler provider: %KDAPI_COMPILER_PROVIDER%

IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
  ECHO [INFO] Supported Visual Studio versions by this build script: 2017, 2019, and 2022
)


@REM Check if cross-compiling
IF "%KDAPI_HOST_ARCH%" NEQ "%KDAPI_TARGET_ARCH%" (
  SET KDAPI_CROSS_COMPILING=true
  ECHO [BUILD] Commpilation type: CROSS_COMPILING
) ELSE (
  SET KDAPI_CROSS_COMPILING=false
  ECHO [BUILD] Commpilation type: NATIVE
)


@REM Check KDAPI_BUILD_TOOLS_PATH
IF NOT DEFINED KDAPI_BUILD_TOOLS_PATH (
  SET "KDAPI_TMP_STR=[WARNING] Build tools path (KDAPI_BUILD_TOOLS_PATH) is not provided."

  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    ECHO !KDAPI_TMP_STR! Build tools globally available assumed.
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    ECHO !KDAPI_TMP_STR! Build tools globally available assumed.
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    IF "%KDAPI_CROSS_COMPILING%"=="true" (
      ECHO !KDAPI_TMP_STR! Assumed using '!KDAPI_HOST_ARCH!_!KDAPI_TARGET_ARCH! Cross Tools for Visual Studio' environment.
    ) ELSE (
      ECHO !KDAPI_TMP_STR! Assumed using '!KDAPI_HOST_ARCH! Native Tools for Visual Studio' environment.
    )
  )
)


@REM Check KDAPI_COMPILER_NAME
IF DEFINED KDAPI_COMPILER_NAME (
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    ECHO [BUILD] '%KDAPI_COMPILER_NAME%' will be used as compiler instead of 'gcc.exe'
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    ECHO [BUILD] '%KDAPI_COMPILER_NAME%' will be used as compiler instead of 'clang.exe'
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    ECHO [BUILD] '%KDAPI_COMPILER_NAME%' will be used as compiler instead of 'cl.exe'
  )
) ELSE (
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    SET KDAPI_COMPILER_NAME=gcc.exe
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    SET KDAPI_COMPILER_NAME=clang.exe
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    SET KDAPI_COMPILER_NAME=cl.exe
  )
)

IF DEFINED KDAPI_BUILD_TOOLS_PATH IF "%KDAPI_COMPILER_PROVIDER%" NEQ "msvc" (
  SET KDAPI_COMPILER="%KDAPI_BUILD_TOOLS_PATH%\%KDAPI_COMPILER_NAME%"
) ELSE (
  SET KDAPI_COMPILER=%KDAPI_COMPILER_NAME%
)

ECHO [BUILD] Compiler: %KDAPI_COMPILER%


@REM Check KDAPI_BUILD_TYPE
IF NOT DEFINED KDAPI_BUILD_TYPE (
  SET KDAPI_BUILD_TYPE=release
) ELSE (
  FOR %%i IN (%KDAPI_BUILD_TYPE_LIST%) DO (
    IF "%%i"=="%KDAPI_BUILD_TYPE%" (
      GOTO :KDAPI_BUILD_TYPE_FOUND
    )
  )

  ECHO [ERROR] The provided build type is not supported by this build script ^(KDAPI_BUILD_TYPE="%KDAPI_BUILD_TYPE%"^).
  GOTO :_KDAPI_ENVIRONMENT_INFO
)

:KDAPI_BUILD_TYPE_FOUND
ECHO [BUILD] Build type: %KDAPI_BUILD_TYPE%


@REM Output postfixes
SET KDAPI_BUILD_POSTFIX=

IF "%KDAPI_BUILD_TYPE%"=="debug" (
  SET KDAPI_BUILD_POSTFIX=-d
)


@REM Debugger flag
SET KDAPI_DEBUG_FLAG=

IF "%KDAPI_BUILD_TYPE%"=="debug" (
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    SET KDAPI_DEBUG_FLAG=-ggdb
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    SET KDAPI_DEBUG_FLAG=-g
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    SET KDAPI_DEBUG_FLAG=/DEBUG
  )
)


@REM Optimize flag
SET KDAPI_COMPILER_OPTIMIZE_FLAGS=

IF "%KDAPI_COMPILER_OPTIMIZE%"=="true" IF "%KDAPI_BUILD_TYPE%"=="release" (
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    SET KDAPI_COMPILER_OPTIMIZE_FLAGS=-O2
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    SET KDAPI_COMPILER_OPTIMIZE_FLAGS=-O2
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    SET KDAPI_COMPILER_OPTIMIZE_FLAGS=/O2
  )
)


@REM Warnings flag
SET KDAPI_WARNING_FLAG=

IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
  SET "KDAPI_WARNING_FLAG=-Wall -Werror -Wextra -pedantic"
) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
  SET "KDAPI_WARNING_FLAG=-Wall -Werror -Wextra -Wpedantic"
) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
  SET "KDAPI_WARNING_FLAG=/W4 /WX /permissive-"
)


@REM Output binaries
SET KDAPI_OBJECT_NAME=%KDAPI_OUTPUT_NAME%%KDAPI_BUILD_POSTFIX%
SET KDAPI_EXEC_FILE=%KDAPI_OBJECT_NAME%.exe

IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
  SET KDAPI_OBJECT_FILE=%KDAPI_OBJECT_NAME%.o
) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
  SET KDAPI_OBJECT_FILE=%KDAPI_OBJECT_NAME%.o
) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
  SET KDAPI_OBJECT_FILE=%KDAPI_OBJECT_NAME%.obj
)


@REM Initialize environment
IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" IF DEFINED KDAPI_BUILD_TOOLS_PATH (
  SET "KDAPI_ENV_PATH=!KDAPI_BUILD_TOOLS_PATH!\VC\Auxiliary\Build"

  IF "%KDAPI_CROSS_COMPILING%"=="true" (
    ECHO [BUILD] Initializing Visual Studio build environment for !KDAPI_HOST_ARCH!_!KDAPI_TARGET_ARCH! cross tools...

    IF "%KDAPI_HOST_ARCH%"=="x86" (
      CALL "!KDAPI_ENV_PATH!\vcvarsx86_amd64.bat"
    ) ELSE IF "%KDAPI_HOST_ARCH%"=="x64" (
      CALL "!KDAPI_ENV_PATH!\vcvarsamd64_x86.bat"
    )
  ) ELSE (
    ECHO [BUILD] Initializing Visual Studio build environment for !KDAPI_HOST_ARCH! native tools...

    IF "%KDAPI_HOST_ARCH%"=="x86" (
      CALL "!KDAPI_ENV_PATH!\vcvars32.bat"
    ) ELSE IF "%KDAPI_HOST_ARCH%"=="x64" (
      CALL "!KDAPI_ENV_PATH!\vcvars64.bat"
    )
  )
)


ECHO [BUILD] Started building...


@REM Output directories
SET KDAPI_BUILD_DIR=build
SET KDAPI_BIN_DIR=%KDAPI_BUILD_DIR%\bin

IF NOT EXIST %KDAPI_BUILD_DIR% (
  MKDIR %KDAPI_BUILD_DIR%
  ECHO [BUILD] Created directory: %KDAPI_BUILD_DIR%
)

IF NOT EXIST %KDAPI_BIN_DIR% (
  MKDIR %KDAPI_BIN_DIR%
  ECHO [BUILD] Created directory: %KDAPI_BIN_DIR%
)

IF "%KDAPI_CROSS_COMPILING%"=="true" (
  IF "%KDAPI_HOST_ARCH%"=="x86" (
    SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\x86_x64
  ) ELSE IF "%KDAPI_HOST_ARCH%"=="x64" (
    SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\x64_x86
  )
) ELSE (
  IF "%KDAPI_TARGET_ARCH%"=="x86" (
    SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\x86
  ) ELSE IF "%KDAPI_TARGET_ARCH%"=="x64" (
    SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\x64
  )
)

IF NOT EXIST %KDAPI_BIN_DIR% (
  MKDIR %KDAPI_BIN_DIR%
  ECHO [BUILD] Created directory: %KDAPI_BIN_DIR%
)

IF "%KDAPI_BUILD_TYPE%"=="debug" (
  SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\debug
) ELSE IF "%KDAPI_BUILD_TYPE%"=="release" (
  SET KDAPI_BIN_DIR=%KDAPI_BIN_DIR%\release
)

IF NOT EXIST %KDAPI_BIN_DIR% (
  MKDIR %KDAPI_BIN_DIR%
  ECHO [BUILD] Created directory: %KDAPI_BIN_DIR%
)


@REM Build the target
IF "%KDAPI_TARGET_ARCH%"=="x86" (
  GOTO :_KDAPI_ARCH_32BIT_BUILD
) ELSE IF "%KDAPI_TARGET_ARCH%"=="x64" (
  GOTO :_KDAPI_ARCH_64BIT_BUILD
)


@REM For 32-bit build
:_KDAPI_ARCH_32BIT_BUILD
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    SET KDAPI_TARGET_ARCH_FLAG=-m32
    GOTO :_KDAPI_MINGW_BUILD
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    @REM SET KDAPI_TARGET_ARCH_FLAG=-m32
    SET KDAPI_TARGET_ARCH_FLAG=--target=i686-pc-windows-msvc
    GOTO :_KDAPI_LLVM_BUILD
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    SET KDAPI_TARGET_ARCH_FLAG=/MACHINE:X86
    GOTO :_KDAPI_MSVC_BUILD
  )
  GOTO :_KDAPI_COMPLETE


@REM For 64-bit build
:_KDAPI_ARCH_64BIT_BUILD
  IF "%KDAPI_COMPILER_PROVIDER%"=="mingw" (
    SET KDAPI_TARGET_ARCH_FLAG=-m64
    GOTO :_KDAPI_MINGW_BUILD
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="llvm" (
    @REM SET KDAPI_TARGET_ARCH_FLAG=-m64
    SET KDAPI_TARGET_ARCH_FLAG=--target=x86_64-pc-windows-msvc
    GOTO :_KDAPI_LLVM_BUILD
  ) ELSE IF "%KDAPI_COMPILER_PROVIDER%"=="msvc" (
    SET KDAPI_TARGET_ARCH_FLAG=/MACHINE:X64
    GOTO :_KDAPI_MSVC_BUILD
  )
  GOTO :_KDAPI_COMPLETE


@REM For MINGW build
:_KDAPI_MINGW_BUILD
  ECHO [BUILD] Compiling object files...
  SET "KDAPI_TMP_CMD=%KDAPI_COMPILER% -std=iso9899:1990 %KDAPI_COMPILER_OPTIMIZE_FLAGS% %KDAPI_TARGET_ARCH_FLAG% %KDAPI_DEBUG_FLAG% %KDAPI_WARNING_FLAG% -c %KDAPI_SOURCE_DIR%\test.c -I%KDAPI_INCLUDE_DIR% -o %KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE%"
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  SET "KDAPI_TMP_CMD=%KDAPI_COMPILER% %KDAPI_TARGET_ARCH_FLAG% %KDAPI_DEBUG_FLAG% %KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE% -o %KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%"
  ECHO [BUILD] Building executable...
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  GOTO :_KDAPI_COMPLETE


@REM For LLVM build
:_KDAPI_LLVM_BUILD
  ECHO [BUILD] Compiling object files...
  SET "KDAPI_TMP_CMD=%KDAPI_COMPILER% -std=c89 %KDAPI_COMPILER_OPTIMIZE_FLAGS% %KDAPI_TARGET_ARCH_FLAG% %KDAPI_DEBUG_FLAG% %KDAPI_WARNING_FLAG% -c %KDAPI_SOURCE_DIR%\test.c -I%KDAPI_INCLUDE_DIR% -o %KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE%"
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  ECHO [BUILD] Building executable...
  SET "KDAPI_TMP_CMD=%KDAPI_COMPILER% %KDAPI_TARGET_ARCH_FLAG% %KDAPI_DEBUG_FLAG% %KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE% -o %KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%"
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  GOTO :_KDAPI_COMPLETE


@REM For MSVC build
:_KDAPI_MSVC_BUILD
  ECHO [BUILD] Compiling object files...
  SET "KDAPI_TMP_CMD=%KDAPI_COMPILER% /Za /c %KDAPI_COMPILER_OPTIMIZE_FLAGS% %KDAPI_DEBUG_FLAG% %KDAPI_WARNING_FLAG% /Fo%KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE% /I%KDAPI_INCLUDE_DIR% %KDAPI_SOURCE_DIR%\test.c"
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  ECHO [BUILD] Building executable...
  SET "KDAPI_TMP_CMD=link.exe %KDAPI_DEBUG_FLAG% %KDAPI_TARGET_ARCH_FLAG% %KDAPI_BIN_DIR%\%KDAPI_OBJECT_FILE% /OUT:%KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%"
  ECHO [CMD] %KDAPI_TMP_CMD%
  %KDAPI_TMP_CMD%

  GOTO :_KDAPI_COMPLETE


:_KDAPI_COMPLETE
  ECHO [BUILD] Finished building.

  IF "%KDAPI_RUN_TEST_CMD%"=="true" (
    GOTO :_KDAPI_RUN_EXEC
  ) ELSE (
    ECHO [INFO] To run use command:  `.\%KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%`
  )

  @REM Clean up previous builds
  IF "%KDAPI_RUN_INSTALL_CMD%"=="true" (
    IF EXIST "%KDAPI_INSTALL_FILE%" (
      ECHO [BUILD] Installing project...
      ECHO -----------------------------
      CALL %KDAPI_INSTALL_FILE%
      ECHO -----------------------------
      ECHO [BUILD] Project installed.
    )
  )

  EXIT /B 0


:_KDAPI_ERROR_EXIT
  ECHO [BUILD] Error(s) occured. Could not finish building.
  EXIT /B 1


:_KDAPI_RUN_EXEC
  ECHO [BUILD] Running the test executable...
  ECHO [CMD] .\%KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%
  ECHO --------------------------------------
  ECHO.
  
  .\%KDAPI_BIN_DIR%\%KDAPI_EXEC_FILE%
  
  ECHO.
  ECHO --------------------------------------
  ECHO [BUILD] Finished running.

  EXIT /B 0

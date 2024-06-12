@REM file: clean.bat
@REM author: Kumarjit Das
@REM date: 2024-06-12
@REM brief: Clean script file for project builds.
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


ECHO [CLEAN] Cleaning up builds...


@REM Build directories
SET KDAPI_BUILD_DIR=build
SET KDAPI_LIB_DIR=%KDAPI_BUILD_DIR%\lib
SET KDAPI_BIN_DIR=%KDAPI_BUILD_DIR%\bin


IF "%~1"=="all" (
  IF EXIST "%KDAPI_BUILD_DIR%" (
    ECHO [CLEAN] Removing the entire build directory...
    RMDIR /S /Q "%KDAPI_BUILD_DIR%"
    ECHO [CLEAN] All the contents of "%KDAPI_BUILD_DIR%" directory including itself have been deleted.
  ) ELSE (
    ECHO [CLEAN] "%KDAPI_BUILD_DIR%" does not exist.
    GOTO :_KDAPI_NOTHING_TO_CLEAN
  )

  GOTO :_KDAPI_COMPLETE
)


IF NOT EXIST "%KDAPI_LIB_DIR%" IF NOT EXIST "%KDAPI_BIN_DIR%" (
  GOTO :_KDAPI_NOTHING_TO_CLEAN
)


@REM Clean the lib directory
IF EXIST "%KDAPI_LIB_DIR%" (
  ECHO [CLEAN] Removing contents of "%KDAPI_LIB_DIR%"...

  @REM Delete all files in the directory
  DEL /Q "%KDAPI_LIB_DIR%\*.*"

  @REM Delete all subdirectories and their contents
  FOR /D %%x IN ("%KDAPI_LIB_DIR%\*") DO RMDIR /S /Q "%%x"

  ECHO [CLEAN] All the contents of "%KDAPI_LIB_DIR%" has been removed.
) ELSE (
  ECHO [CLEAN] "%KDAPI_LIB_DIR%" does not exist.
)


@REM Clean the bin directory
IF EXIST "%KDAPI_BIN_DIR%" (
  ECHO [CLEAN] Removing contents of "%KDAPI_BIN_DIR%"...

  @REM Delete all files in the directory
  DEL /Q "%KDAPI_BIN_DIR%\*.*"

  @REM Delete all subdirectories and their contents
  FOR /D %%x IN ("%KDAPI_BIN_DIR%\*") DO RMDIR /S /Q "%%x"

  ECHO [CLEAN] All the contents of "%KDAPI_BIN_DIR%" has been deleted.
) ELSE (
  ECHO [CLEAN] "%KDAPI_BIN_DIR%" does not exist.
)


:_KDAPI_COMPLETE
  ECHO [CLEAN] Cleaning completed.
  EXIT /B 0


:_KDAPI_NOTHING_TO_CLEAN
  ECHO [CLEAN] Nothing to clean.
  EXIT /B 0

@REM file: install.bat
@REM author: Kumarjit Das
@REM date: 2024-06-02
@REM brief: Install script file for project builds.
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


SET _KDAPI_GOTO_ENVIRONMENT_INFO=false
SET _KDAPI_GOTO_ENTRY=true
SET _KDAPI_GOTO_COMPLETE=false
SET _KDAPI_GOTO_ERROR_EXIT=false
SET "TAB=	"


:_KDAPI_CHOOSE_GOTO
  IF "%_KDAPI_GOTO_ENTRY%"=="true" (
    SET _KDAPI_GOTO_ENTRY=false
    GOTO :_KDAPI_ENTRY
  ) ELSE IF "%_KDAPI_GOTO_ENVIRONMENT_INFO%"=="true" (
    SET _KDAPI_GOTO_ENVIRONMENT_INFO=false
    GOTO :_KDAPI_ENVIRONMENT_INFO
  ) ELSE IF "%_KDAPI_GOTO_COMPLETE%"=="true" (
    SET _KDAPI_GOTO_COMPLETE=false
    GOTO :_KDAPI_COMPLETE
  ) ELSE IF "%_KDAPI_GOTO_ERROR_EXIT%"=="true" (
    SET _KDAPI_GOTO_ERROR_EXIT=false
    GOTO :_KDAPI_ERROR_EXIT
  )

  ECHO [!!!] EXITING INSTALL.
  EXIT /B 0


:_KDAPI_ENVIRONMENT_INFO
  ECHO --------------------------------------------------------------------------------
  ECHO Make sure to set these environment variables before running this script.
  ECHO You can create an environment setup batch file for this. By default this install
  ECHO script will search for 'setup_env.bat'.
  ECHO.
  ECHO These are the environment variables:

  ECHO %TAB%- KDAPI_SETUP_ENV_FILE ^(optional^) ^(default: setup_env.bat^)
  ECHO %TAB%- KDAPI_INSTALL_LOCATION ^(optional^) ^(default: %~dp0)
  ECHO %TAB%- KDAPI_INSTALL_NAME
  ECHO %TAB%- KDAPI_INSTALL_VERSION
  ECHO %TAB%- KDAPI_INSTALL_INCLUDE_FILES

  GOTO :_KDAPI_CHOOSE_GOTO


:_KDAPI_ENTRY
  ECHO [INSTALL] Initializing install...


@REM Set the environment
IF NOT DEFINED KDAPI_SETUP_ENV_FILE (
  SET KDAPI_SETUP_ENV_FILE=setup_env.bat
)

IF EXIST "%KDAPI_SETUP_ENV_FILE%" (
  ECHO [INSTALL] Setup file found ^(%KDAPI_SETUP_ENV_FILE%^)
  ECHO [INSTALL] Setting up install environment...
  ECHO ---------------------------------------
  CALL %KDAPI_SETUP_ENV_FILE%
  ECHO ---------------------------------------
  ECHO [INSTALL] Install environment setup completed.
) ELSE (
  ECHO [ERROR] Setup environment file ^(%KDAPI_SETUP_ENV_FILE%^) does not exist.
  ECHO [INSTALL] Install environment setup not done. Continueing...
)


@REM Check KDAPI_INSTALL_LOCATION
IF NOT DEFINED KDAPI_INSTALL_LOCATION (
  SET KDAPI_INSTALL_LOCATION=%~dp0
)

IF NOT EXIST "%KDAPI_INSTALL_LOCATION%" (
  ECHO [INSTALL] Provided location/directory ^(%KDAPI_INSTALL_LOCATION%^) does not exist.
  SET _KDAPI_GOTO_ERROR_EXIT=true
  GOTO :_KDAPI_CHOOSE_GOTO
)

ECHO [INSTALL] Install location: %KDAPI_INSTALL_LOCATION%


@REM Check KDAPI_INSTALL_NAME
IF NOT DEFINED KDAPI_INSTALL_NAME (
  ECHO [ERROR] `KDAPI_INSTALL_NAME` is not set.
  SET _KDAPI_GOTO_ENVIRONMENT_INFO=true
  SET _KDAPI_GOTO_ERROR_EXIT=true
  GOTO :_KDAPI_CHOOSE_GOTO
)

ECHO [INSTALL] Install directory name: %KDAPI_INSTALL_NAME%


@REM Check KDAPI_INSTALL_VERSION
IF NOT DEFINED KDAPI_INSTALL_VERSION (
  ECHO [ERROR] `KDAPI_INSTALL_VERSION` is not set.
  SET _KDAPI_GOTO_ENVIRONMENT_INFO=true
  SET _KDAPI_GOTO_ERROR_EXIT=true
  GOTO :_KDAPI_CHOOSE_GOTO
)

ECHO [INSTALL] Install version: %KDAPI_INSTALL_VERSION%


@REM Check KDAPI_INSTALL_INCLUDE_FILES
IF NOT DEFINED KDAPI_INSTALL_INCLUDE_FILES (
  ECHO [ERROR] `KDAPI_INSTALL_INCLUDE_FILES` is not set.
  SET _KDAPI_GOTO_ENVIRONMENT_INFO=true
  SET _KDAPI_GOTO_ERROR_EXIT=true
  GOTO :_KDAPI_CHOOSE_GOTO
)

ECHO [INSTALL] Include files: %KDAPI_INSTALL_INCLUDE_FILES%


ECHO [INSTALL] Started installing...


@REM Create the install directory
SET "KDAPI_INSTALL_DIR=%KDAPI_INSTALL_LOCATION%\%KDAPI_INSTALL_NAME%-%KDAPI_INSTALL_VERSION%"
MKDIR "%KDAPI_INSTALL_DIR%"
ECHO [INSTALL] Created install directory ^("%KDAPI_INSTALL_DIR%"^).


@REM Copy include files
FOR %%f IN (%KDAPI_INSTALL_INCLUDE_FILES%) DO (
  IF EXIST "%%f" (
    COPY "%%f" "%KDAPI_INSTALL_DIR%\" >nul
    ECHO [INSTALL] Copied %%f to %KDAPI_INSTALL_DIR%
  ) ELSE (
    ECHO [ERROR] File ^(%%f^) does not exist.
    SET _KDAPI_GOTO_ERROR_EXIT=true
    GOTO :_KDAPI_CHOOSE_GOTO
  )
)

ECHO [INSTALL] Copied all include files.


@REM Copy license, readme, and release-notes files
SET "KDAPI_INSTALL_OTHER_FILES="LICENSE.txt" "README.md" "Release Notes.md""
FOR %%f IN (%KDAPI_INSTALL_OTHER_FILES%) DO (
  IF EXIST "%%f" (
    COPY %%f "%KDAPI_INSTALL_DIR%\" >nul
    ECHO [INSTALL] Copied %%f to %KDAPI_INSTALL_DIR%
  ) ELSE (
    ECHO [ERROR] File ^(%%f^) does not exist.
    SET _KDAPI_GOTO_ERROR_EXIT=true
    GOTO :_KDAPI_CHOOSE_GOTO
  )
)

ECHO [INSTALL] Copied license, readme, and release-notes files.


GOTO :_KDAPI_COMPLETE


:_KDAPI_ERROR_EXIT
  ECHO [ERROR] Error(s) occured. Could not finish installing.
  
  SET TAB=
  SET _KDAPI_GOTO_ENVIRONMENT_INFO=
  SET _KDAPI_GOTO_ENTRY=
  SET _KDAPI_GOTO_COMPLETE=
  SET _KDAPI_GOTO_ERROR_EXIT=
  SET KDAPI_SETUP_ENV_FILE=
  SET KDAPI_INSTALL_LOCATION=
  SET KDAPI_INSTALL_NAME=
  SET KDAPI_INSTALL_VERSION=
  SET KDAPI_INSTALL_INCLUDE_FILES=
  
  EXIT /B 1


:_KDAPI_COMPLETE
  ECHO [INSTALL] Finished installing.
  
  SET TAB=
  SET _KDAPI_GOTO_ENVIRONMENT_INFO=
  SET _KDAPI_GOTO_ENTRY=
  SET _KDAPI_GOTO_COMPLETE=
  SET _KDAPI_GOTO_ERROR_EXIT=
  SET KDAPI_SETUP_ENV_FILE=
  SET KDAPI_INSTALL_LOCATION=
  SET KDAPI_INSTALL_NAME=
  SET KDAPI_INSTALL_VERSION=
  SET KDAPI_INSTALL_INCLUDE_FILES=

  EXIT /B 0

# Release Notes

## [v1.1.0](https://github.com/KumarjitDas/kdapi/releases/tag/v1.1.0)

*20th June, 2024*

### Enhancements

- **Environment Setup Scripts**: Added setup scripts (`setup_env.sh`, `setup_env.bat`) for both Linux and Windows.
- **Build System**: Improved build scripts (`build.sh`, `build.bat`) to handle compilation and linking processes.
- **Clean and Install Scripts**: Added scripts for cleaning (`clean.sh`, `clean.bat`) and installing (`install.sh`, `install.bat`) the library.
- **Example Program**: Included an example test program (`test.c`) to demonstrate the usage of the library.
- **Documentation**: Updated `README.md` with detailed installation and usage instructions.

### Bug Fixes

- **C89 Compatibility**: Changed the single line comments (`//`) to multi-line comments (`/* */`).
- **Build Scripts**: Resolved minor bugs and inconsistencies in the build scripts.
- **Error Handling**: Enhanced error handling in the environment setup scripts.

## [v1.0.0](https://github.com/KumarjitDas/kdapi/releases/tag/v1.0.0)

*15th May, 2024*

### Features

- **Compiler Detection**: Added macros to detect various compilers including Intel, GCC, LLVM, and more.
- **OS Identification**: Introduced macros to identify the target operating system such as Linux, Windows, etc.
- **CPU Architecture Detection**: Added macros for detecting the target CPU architecture (x86, x64, ARM, etc.).
- **Endianness Determination**: Added macros to determine the system endianness (little-endian, big-endian).
- **DLL Handling**: Provided import-export macros for DLL handling.
- **Calling Conventions**: Introduced macros for calling conventions (cdecl, stdcall, fastcall).

For more details, see the full [Changelog](CHANGELOG.md).

## Version Details

- **Release Version**: 1.1.0
- **Release Date**: 2024-06-19
- **Previous Version**: 1.0.0

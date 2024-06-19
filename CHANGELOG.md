# Changelog

All notable changes to this project will be documented in this file.

## [v1.1.0](https://github.com/KumarjitDas/kdapi/compare/v1.0.0...v1.1.0) - 2024-06-20

### Added

- Environment setup scripts (`setup_env.sh`, `setup_env.bat`) for both Linux and Windows.
- Build scripts (`build.sh`, `build.bat`) for compiling and linking the project.
- Clean scripts (`clean.sh`, `clean.bat`) for removing build artifacts.
- Install scripts (`install.sh`, `install.bat`) for setting up the library.

### Changed

- Changed the single line comments to multi-line ones for C89 compatibility.
- Updated `README.md` to include detailed installation and usage instructions.
- Improved documentation and comments in code files.

### Removed

- The make file `makefile` for building project.

## [v1.0.0](https://github.com/KumarjitDas/kdapi/releases/tag/v1.0.0) - 2024-05-15

### Added

- Compiler detection macros for various compilers (Intel, GCC, LLVM, etc.).
- Target operating system identification macros (Linux, Windows, etc.).
- Target CPU architecture detection macros (x86, x64, ARM, etc.).
- Endianness determination macros (little-endian, big-endian).
- Import-export macros for DLL handling.
- Calling convention macros (cdecl, stdcall, fastcall).
- Example test program (`test.c`) demonstrating the library usage.

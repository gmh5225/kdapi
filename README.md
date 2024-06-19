
# KDAPI

KDAPI is a simple, header-only C library designed to provide compile-time system information. This project targets both Windows and GNU/Linux (32-bit and 64-bit) platforms. The library aims to help developers easily retrieve details about the compiler, target operating system, target CPU, and endianness at compile-time.

## Table of Contents

- [KDAPI](#kdapi)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Installation](#installation)
  - [Requirements](#requirements)
  - [Getting Started](#getting-started)
    - [Setup Environment](#setup-environment)
      - [On Linux](#on-linux)
      - [On Windows](#on-windows)
    - [Building the Project](#building-the-project)
      - [On Linux](#on-linux-1)
      - [On Windows](#on-windows-1)
    - [Cleaning the Build](#cleaning-the-build)
      - [On Linux](#on-linux-2)
      - [On Windows](#on-windows-2)
    - [Installing the Project](#installing-the-project)
      - [On Linux](#on-linux-3)
      - [On Windows](#on-windows-3)
  - [Usage](#usage)
    - [Example](#example)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [Naming Convention](#naming-convention)
  - [License](#license)
  - [Project Status](#project-status)
  - [Acknowledgment](#acknowledgment)
  - [Contact](#contact)
  - [Versioning](#versioning)
  - [Changelog](#changelog)

## Features

- Detects compiler type and version.
- Identifies the target operating system.
- Determines the target CPU architecture.
- Checks system endianness.
- Provides macros for import-export signatures, calling conventions, and extern indicators.

## Installation

To get started with this project, download and install the following.

- Download and install **git**
  - If you use *Windows*, then go to [this link](https://git-scm.com/downloads) and download and install the suitable
    version.
  - If you use any stable version of *Debian/Ubuntu* then run this command in your terminal

    ```sh
    sudo apt-get install git
    ```

  - If you use *macOS* then install [homebrew](https://brew.sh/) if you don't already have it, then run this command
    in your terminal

    ```sh
    brew install git
    ```

- Run the command to clone this repository

  ```sh
  git clone https://github.com/KumarjitDas/kdapi.git
  ```

- Download and install a **C** compiler (*clang* or *gcc*)
  - If you use *Windows 10* then download and install a suitable version of **clang** from
    [this](https://releases.llvm.org/download.html) link. For **gcc**, use the suitable *MinGW* version from
    [this](http://mingw-w64.org/doku.php/download) link.
  - If you use any stable version of *Debian/Ubuntu* then run these commands in your terminal to download and install
    **clang** and **gcc** compilers

    ```sh
    sudo apt install clang
    ```

    ```sh
    sudo apt install gcc
    ```

  - In *macOS*, **clang** is the default **C** compiler. To download and install gcc, run this command in your terminal

    ```sh
    brew install gcc
    ```

## Requirements

- For building on Linux 32-bit targets on a 64-bit platform, `gcc-multilib` must be installed:

  ```bash
  sudo apt install gcc-multilib
  ```

## Getting Started

Users need to set up their environment using the provided template setup files. The `setup_env.*` files in the root directory are for development purposes and are not provided to the users. Users can create their own setup files or copy the template files from the `templates` directory.

### Setup Environment

Copy the template setup files:

#### On Linux

Run the build script:

```bash
cp templates/setup_env.template.sh setup_env.sh
```

#### On Windows

Run the build script:

```batch
COPY templates\setup_env.template.bat setup_env.bat
```

Modify the `setup_env.sh` and `setup_env.bat` files to match your build environment.

### Building the Project

#### On Linux

Run the build script:

```bash
./build.sh
```

#### On Windows

Run the build script:

```batch
build.bat
```

### Cleaning the Build

#### On Linux

Run the clean script:

```bash
./clean.sh
```

#### On Windows

Run the clean script:

```batch
clean.bat
```

### Installing the Project

#### On Linux

Run the install script:

```bash
./install.sh
```

#### On Windows

Run the install script:

```batch
install.bat
```

## Usage

Include the `kdapi.h` header file in your C project to use KDAPI.

```c
#include "kdapi.h"
```

### Example

An example usage of KDAPI can be found in the `test.c` file.

```c
#include <stdio.h>
#include "kdapi.h"

int main() {
    printf("KDAPI Version: %s\n", KD_VERSION_STR);
    return 0;
}
```

## Roadmap

See the [open issues](https://github.com/KumarjitDas/kdapi/issues) for a list of proposed
features/functionalities (and known issues).

The list of features and functions implemented till now is given in [Project Status](#project-status).

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any
contributions you make are greatly appreciated.

- Fork this Project
- Create your *Feature Branch*

  ```sh
  git checkout -b feature/AmazingFeature
  ```

- Commit your *Changes*

  ```sh
  git commit -m 'Add some AmazingFeature'
  ```

- Push to the Branch

  ```sh
  git push origin feature/AmazingFeature
  ```

- Create a *Pull Request*

## Naming Convention

The KDAPI project follows a consistent naming convention to ensure readability and maintainability. Here are the key aspects of the naming convention used:

- **Macro Names**: Macro names are written in uppercase letters with underscores separating words. They typically start with the prefix `KD_`.
  - Examples: `KD_COMPILER_GCC`, `KD_OS_LINUX`, `KD_CPU_X86_64`, `KD_VERSION_MAJOR`

- **Function-Like Macros**: Function-like macros also follow the uppercase with underscores convention and use parentheses to indicate parameters.
  - Examples: `KD_EXTERN_BEGIN`, `KD_EXTERN_END`

- **Constants**: Constants are defined using uppercase letters with underscores and often include a descriptive name or version number.
  - Examples: `KD_VERSION_STR`, `KD_VERSION_MAJOR`

- **File Names**: File names are in lowercase and use underscores to separate words.
  - Examples: `kdapi.h`, `test.c`, `setup_env.sh`

This naming convention helps in clearly identifying different types of identifiers and their purposes within the codebase.

## License

This project is distributed under the **BSD 2-Clause License**. See [LICENSE](LICENSE) for more information.

## Project Status

List of functionalities/features implemented so far:

- Compiler detection (Intel, GCC, LLVM, etc.)
- Target operating system identification (Linux, Windows, etc.)
- Target CPU architecture detection (x86, x64, ARM, etc.)
- Endianness determination (little-endian, big-endian)
- Import-export macros for DLL handling
- Calling convention macros (cdecl, stdcall, fastcall)
- Environment setup scripts for both Linux and Windows
- Build scripts for compiling and linking the project
- Clean scripts for removing build artifacts
- Install scripts for setting up the library
- Example test program demonstrating the library usage


## Acknowledgment

I appreciate these websites which helped me to make such good **README** file, and helped me to learn about project
versioning and keeping **CHANGELOG**.

- [Make a README](https://www.makeareadme.com/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## Contact

Twitter: [@kumarjitdas1999](https://twitter.com/kumarjitdas1999)

LinkedIn:
[Kumarjit Das | কুমারজিৎ দাস](https://www.linkedin.com/in/kumarjit-das/)

E-mail: [kumarjitdas1999@gmail.com](kumarjitdas1999+github@gmail.com)

Project link:
[KDAPI](https://github.com/KumarjitDas/kdapi)

## Versioning

This project uses **MAJOR**, **MINOR**, and **PATCH** version numbers for
versioning (v*MAJOR.MINOR.PATCH*).

- **MAJOR** version number indicates *new changes which may be incompatible with older versions*.
- **MINOR** version number indicates *addition of backwards-compatible features*.
- **PATCH** version number indicates *backwards-compatible bug fixes*, or minor mistake fixes like *spelling*,
  *character cases*, *punctuations*, and *indentation*.

## Changelog

The [Changelog](CHANGELOG.md) file contains all the information about the changes made to this project till now.

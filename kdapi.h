/**
 * @file kdapi.h
 * @author Kumarjit Das
 * @date 2024-05-14
 * @version 1.0.0
 * @brief A simple header-only C library for compile-time system information.
 */
/**
 * LICENSE:
 * 
 * Copyright (c) 2024, Kumarjit Das
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/**
 * Main Usable Components
 * ----------------------
 * 
 * - Get compiler using `KD_COMPILER_<compiler_name>`.
 * - Get target OS using `KD_OS_<os_name>`.
 * - Get target CPU using `KD_CPU_<cpu_name>`.
 * - Use `KD_DLL` when building DLL.
 * - Use `KD_IMPORTEXPORT` for import and export signatures when building DLL.
 * - Use `KDAPI(T)` (T -> return type) for function definitions.
 * - Use `KD_EXTERN_BEGIN` and `KD_EXTERN_END` to wrap function declarations.
 * - Use `KD_LITTLE_ENDIAN` and `KD_BIG_ENDIAN` to determine endianness.
 */


#define KD_DEFINED_LIBKDAPI

#define KD_VERSION_MAJOR 1
#define KD_VERSION_MINOR 0
#define KD_VERSION_PATCH 0


/**
 * ----------
 *  Compiler
 * ----------
 */

#if defined __ECC || defined __ICC || defined __INTEL_COMPILER
  #define KD_COMPILER_INTEL 1
#endif

#if (defined __host_mips || defined __sgi) && !defined __GNUC__
  #define KD_COMPILER_MIPSPRO 1
#endif

#if defined __hpux && !defined __GNUC__
  #define KD_COMPILER_HPCC 1
#endif

#if defined __GNUC__
  #define KD_COMPILER_GCC 1
#endif

#if defined __APPLE_CC__
  #define KD_COMPILER_APPLECC 1
#endif

#if defined __IBMC__ || defined __IBMCPP__
  #define KD_COMPILER_IBM 1
#endif

#if defined _MSC_VER
  #define KD_COMP_MSVC 1
#endif

#if defined __SUNPRO_C
  #define KD_COMPILER_SUN 1
#endif

#if defined __BORLANDC__
  #define KD_COMPILER_BORLAND 1
#endif

#if defined __MWERKS__
  #define KD_COMPILER_METROWERKS 1
#endif

#if defined __DECC || defined __DECCXX
  #define KD_COMPILER_DEC 1
#endif

#if defined __WATCOMC__
  #define KD_COMPILER_WATCOM 1
#endif


/**
 * -------------------------
 *  Target Operating System
 * -------------------------
 */

#if defined linux || defined __linux__
  #define KD_OS_LINUX 1
#endif

#if defined __CYGWIN32__
  #define KD_OS_CYGWIN32 1
#endif

#if defined GEKKO
  #define KD_OS_GAMECUBE
  #define __powerpc__
#endif

#if defined __MINGW32__
  #define KD_OS_MINGW 1
  #define KD_OS_MINGW32 1
#endif

#if defined __MINGW64__
  #define KD_OS_MINGW 1
  #define KD_OS_MINGW64 1
#endif

#if defined GO32 && defined DJGPP && defined __MSDOS__
  #define KD_OS_GO32 1
#endif

/**
 * NOTE: make sure you use /bt=DOS if compiling for 32-bit DOS,
 * otherwise Watcom assumes host=target
 */
#if defined __WATCOMC__ && defined __386__ && defined __DOS__
  #define KD_OS_DOS32 1
#endif

#if defined _UNICOS
  #define KD_OS_UNICOS 1
#endif

#if (defined __MWERKS__ && defined __powerc && !defined macintosh) || defined __APPLE_CC__ || defined macosx
  #define KD_OS_OSX 1
#endif

#if defined __sun__ || defined sun || defined __sun || defined __solaris__
  #if defined __SVR4 || defined __svr4__ || defined __solaris__
    #define KD_OS_SOLARIS 1
  #endif
  #if !defined KD_OS_STRING
    #define KD_OS_SUNOS 1
  #endif
#endif

#if defined __sgi__ || defined sgi || defined __sgi
  #define KD_OS_IRIX 1
#endif

#if defined __hpux__ || defined __hpux
  #define KD_OS_HPUX 1
#endif

#if defined _AIX
  #define KD_OS_AIX 1
#endif

#if (defined __alpha && defined __osf__)
  #define KD_OS_TRU64 1
#endif

#if defined __BEOS__ || defined __beos__
  #define KD_OS_BEOS 1
#endif

#if defined amiga || defined amigados || defined AMIGA || defined _AMIGA
  #define KD_OS_AMIGA 1
#endif

#if defined __unix__
  #define KD_OS_UNIX 1
#endif

#if defined _WIN32_WCE
  #define KD_OS_WINDOWS 1
  #define KD_OS_WINCE 1
#endif

#if defined _XBOX
  #define KD_OS_XBOX 1
#endif

#if defined _WIN32 || defined WIN32 || defined __NT__ || defined __WIN32__
  #define KD_OS_WINDOWS 1
  #define KD_OS_WIN32 1
  #if !defined KD_OS_XBOX && defined _WIN64
    #define KD_OS_WIN64 1
  #endif
#endif

#if defined __palmos__
  #define KD_OS_PALM 1
#endif

#if defined THINK_C || defined macintosh
  #define KD_OS_MACOS 1
#endif


/**
 * ------------
 *  Target CPU
 * ------------
 */

#if defined GEKKO
  #define KD_CPU_PPC750 1
#endif

#if defined mc68000 || defined m68k || defined __MC68K__ || defined m68000
  #define KD_CPU_68K 1
#endif

#if defined __PPC__ || defined __POWERPC__ || defined powerpc || defined _POWER || defined __ppc__ || defined __powerpc__
  #define KD_CPU_PPC 1
  #if defined __powerpc64__
    #define KD_CPU_PPC64 1
  #else
    #define KD_CPU_PPC32 1
  #endif
#endif

#if defined _CRAYT3E || defined _CRAYMPP
  #define KD_CPU_CRAYT3E 1  // target processor is a DEC Alpha 21164 used in a Cray T3E
#endif

#if defined CRAY || defined _CRAY && !defined _CRAYT3E
  #error Non-AXP Cray systems not supported
#endif

#if defined _SH3
  #define KD_CPU_SH3 1
#endif

#if defined __sh4__ || defined __SH4__
  #define KD_CPU_SH3 1
  #define KD_CPU_SH4 1
#endif

#if defined __sparc__ || defined __sparc
  #if defined __arch64__ || defined __sparcv9 || defined __sparc_v9__
    #define KD_CPU_SPARC64 1
  #endif
  #define KD_CPU_SPARC 1
#endif

#if defined ARM || defined __arm__ || defined _ARM
  #define KD_CPU_STRONGARM 1
#endif

#if defined mips || defined __mips__ || defined __MIPS__ || defined _MIPS
  #define KD_CPU_MIPS 1
#endif

#if defined __ia64 || defined _M_IA64 || defined __ia64__
  #define KD_CPU_IA64 1
#endif

#if defined __X86__ || defined __i386__ || defined i386 || defined _M_IX86 || defined __386__ || defined __x86_64__ || defined _M_X64
  #define KD_CPU_X86 1
  #if defined __x86_64__ || defined _M_X64
    #define KD_CPU_X86_64 1
  #endif
#endif

#if defined __alpha || defined alpha || defined _M_ALPHA || defined __alpha__
  #define KD_CPU_AXP 1
#endif

#if defined __hppa || defined hppa
  #define KD_CPU_HPPA 1
#endif


/**
 * --------------------
 *  Calling Convention
 * --------------------
 */

#if defined KD_CPU_X86 && !defined KD_CPU_X86_64
  #if defined __GNUC__
    #define KD_CDECL __attribute__((cdecl))
    #define KD_STDCALL __attribute__((stdcall))
    #define KD_FASTCALL __attribute__((fastcall))
  #elif (defined _MSC_VER || defined __WATCOMC__ || defined __BORLANDC__ || defined __MWERKS__)
    #define KD_CDECL __cdecl
    #define KD_STDCALL __stdcall
    #define KD_FASTCALL __fastcall
  #endif
#else
  #define KD_CDECL
  #define KD_STDCALL
  #define KD_FASTCALL
#endif


/**
 * -------------------------
 *  Import-Export Signature
 * -------------------------
 */

#if defined KD_IMPORTEXPORT
  #undef KD_IMPORTEXPORT
#endif

#if defined KD_DLL
  #if defined KD_OS_WIN32
    #if defined _MSC_VER
      #if (_MSC_VER >= 800)
        #if defined KD_BUILDING_LIB
          #define KD_IMPORTEXPORT __declspec(dllexport)
        #else
          #define KD_IMPORTEXPORT __declspec(dllimport)
        #endif
      #else
        #if defined KD_BUILDING_LIB
          #define KD_IMPORTEXPORT __export
        #else
          #define KD_IMPORTEXPORT
        #endif
      #endif
    #endif  // defined _MSC_VER
    #if defined __BORLANDC__
      #if (__BORLANDC__ >= 0x500)
        #if defined KD_BUILDING_LIB
          #define KD_IMPORTEXPORT __declspec(dllexport)
        #else
          #define KD_IMPORTEXPORT __declspec(dllimport)
        #endif
      #else
        #if defined KD_BUILDING_LIB
          #define KD_IMPORTEXPORT __export
        #else
          #define KD_IMPORTEXPORT
        #endif
      #endif
    #endif  // defined __BORLANDC__
    /* for all other compilers */
    #if defined __GNUC__ || defined __WATCOMC__ || defined __MWERKS__
      #if defined KD_BUILDING_LIB
        #define KD_IMPORTEXPORT __declspec(dllexport)
      #else
        #define KD_IMPORTEXPORT __declspec(dllimport)
      #endif
    #endif  // all other compilers
    #if !defined KD_IMPORTEXPORT
      #error Building DLLs not supported on this compiler
    #endif
  #endif  // defined KD_OS_WIN32
#endif

#if !defined KD_IMPORTEXPORT
  #define KD_IMPORTEXPORT
#endif


/**
 * -----------------------------
 *  Public API Export Signature
 * -----------------------------
 */

#ifdef KDAPI
  #undef KDAPI
#endif

#if ((defined _MSC_VER) && (_MSC_VER < 800)) || (defined __BORLANDC__ && (__BORLANDC__ < 0x500))
  #define KDAPI(T) extern T KD_IMPORTEXPORT
#else
  #define KDAPI(T) extern KD_IMPORTEXPORT T
#endif


/**
 * -------------------
 *  Extern Indicators
 * -------------------
 */

#ifdef __cplusplus
  #define KD_EXTERN_BEGIN extern "C" {
  #define KD_EXTERN_END }
#else
  #define KD_EXTERN_BEGIN
  #define KD_EXTERN_END
#endif


/**
 * ------------
 *  Endianness
 * ------------
 */

#if defined KD_CPU_X86 || defined KD_CPU_AXP || defined KD_CPU_STRONGARM || defined KD_OS_WIN32 || defined KD_OS_WINCE || defined __MIPSEL__
  #define KD_LITTLE_ENDIAN 1
#else
  #define KD_BIG_ENDIAN 1
#endif

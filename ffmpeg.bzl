"""Macros and constants for building FFmpeg with Bazel."""

load("@rules_cc//cc:cc_test.bzl", "cc_test")

# FFmpeg requires config.h to be included before any system headers (like math.h)
# to prevent conflicts between system declarations and FFmpeg's internal overrides.
# Since many FFmpeg source files omit this include or include it too late, we
# use the compiler's -include flag to force it at "Line 0".
_FORCED_INCLUDES = select({
    "//:linux_x86_64": [
        "-include platform/linux-x86_64/config.h",
        "-include platform/linux-x86_64/config_components.h",
    ],
    "//:linux_aarch64": [
        "-include platform/linux-aarch64/config.h",
        "-include platform/linux-aarch64/config_components.h",
    ],
    "//:darwin_aarch64": [
        "-include platform/darwin-aarch64/config.h",
        "-include platform/darwin-aarch64/config_components.h",
    ],
    "//:windows_x86_64": [
        "/FIplatform/windows-x86_64/config.h",
        "/FIplatform/windows-x86_64/config_components.h",
    ],
    # Default to linux-x86_64 if none match
    "//conditions:default": [
        "-include platform/linux-x86_64/config.h",
        "-include platform/linux-x86_64/config_components.h",
    ],
})

# Standard Clang flags (Linux x86_64)
# Enables AVX2, FMA, and the AVX-512 Foundation + Conflict Detection
_INTEL_AVX512_POSIX = [
    "-mavx2",
    "-mfma",
    # Not supported on our cloud gcen builders yet
    # "-mavx512f",
    # "-mavx512cd",
]

# Clang-cl flags (Windows x86_64)
# Note: /arch:AVX2 is native MSVC style; others require /clang: prefix
_INTEL_AVX512_MSVC = [
    "/arch:AVX2",
    "/clang:-mfma",
    # Not supported on our cloud gcen builders yet
    # "/clang:-mavx512f",
    # "/clang:-mavx512cd",
]

_BASE_COPTS = [
    "-DHAVE_AV_CONFIG_H=1",
    "-D_FILE_OFFSET_BITS=64",
    "-D_LARGEFILE_SOURCE",
    "-DZLIB_CONST",
]

_POSIX_COPTS = [
    "-Wno-deprecated-declarations",
    "-Wno-pointer-sign",
    "-Wno-switch",
    "-Wno-unused-function",
    "-Wno-shift-op-parentheses",
    "-Wno-logical-op-parentheses",
    "-Wno-parentheses",
    "-Wno-unused-const-variable",
    "-Wno-implicit-const-int-float-conversion",
    "-D_GNU_SOURCE=1",
    "-D_XOPEN_SOURCE=600",
    "-fPIC",
    "-DPIC",
]

_DARWIN_COPTS = [
    "-Wno-deprecated-declarations",
    "-Wno-pointer-sign",
    "-Wno-switch",
    "-Wno-unused-function",
    "-Wno-shift-op-parentheses",
    "-Wno-logical-op-parentheses",
    "-Wno-implicit-const-int-float-conversion",
    "-Wno-unused-const-variable",
    "-Wno-parentheses",
    "-D_DARWIN_C_SOURCE",
    "-D_XOPEN_SOURCE=600",
    "-fPIC",
    "-DPIC",
]

_MSVC_COPTS = [
    "/wd4018",  # 'expression' : signed/unsigned mismatch
    "/wd4090",  # 'operation' : different 'modifier' qualifiers
    "/wd4101",  # 'identifier' : unreferenced local variable
    "/wd4146",  # unary minus operator applied to unsigned type, result still unsigned
    "/wd4244",  # 'argument' : conversion from 'type1' to 'type2', possible loss of data
    "/wd4267",  # 'var' : conversion from 'size_t' to 'type', possible loss of data
    "/wd4305",  # 'identifier' : truncation from 'type1' to 'type2'
    "/wd4334",  # 'operator' : result of 32-bit shift implicitly converted to 64 bits
    "/wd4554",  # 'operator' : check operator precedence for possible error
    "/wd4996",  # The compiler encountered a deprecated declaration
    "-DPIC",
]

# --- Updated Select Statement ---

CC_COPTS = _FORCED_INCLUDES + _BASE_COPTS + select({
    # Windows: Add MSVC specific AVX flags
    "//:windows_x86_64": _MSVC_COPTS + _INTEL_AVX512_MSVC,

    # MacOS ARM: Keep as is (No AVX)
    "//:darwin_aarch64": _DARWIN_COPTS,

    # Linux x86: Explicitly add POSIX AVX flags here
    "//:linux_x86_64": _POSIX_COPTS + _INTEL_AVX512_POSIX,

    # Linux ARM: Explicitly use standard POSIX opts (No AVX) to prevent build failure
    "//:linux_aarch64": _POSIX_COPTS,

    # Fallback (assumes x86_64 as per your include logic)
    "//conditions:default": _POSIX_COPTS + _INTEL_AVX512_POSIX,
})

def ffmpeg_cc_test(name, srcs, deps = [], copts = [], **kwargs):
    """A wrapper around cc_test that includes standard FFmpeg compiler options.

    Args:
        name: The name of the test target.
        srcs: The source files for the test.
        deps: The dependencies for the test.
        copts: Additional compiler options.
        **kwargs: Additional arguments passed to cc_test.
    """
    cc_test(
        name = name,
        srcs = srcs,
        copts = CC_COPTS + copts,
        deps = deps + [
            "//:config_h",
        ],
        **kwargs
    )

class EbpfCacheProfiler < Formula
  desc "CPU cache profiler with per-process L1/L2/LLC statistics using eBPF"
  homepage "https://github.com/Joseda8/ebpf-cache-profiler"
  # no upstream releases; version from meson.build project declaration
  url "https://github.com/Joseda8/ebpf-cache-profiler/archive/fb45b79abdbc834b64c1a5b9b183c0ed4d3d582b.tar.gz"
  version "0.1.0"
  sha256 "b67de0f4c2c1326462ab8a9ad510bd996d3e406fee9e0534fd9f6eae253e5c89"
  license :cannot_represent
  head "https://github.com/Joseda8/ebpf-cache-profiler.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libbpf"
  depends_on :linux
  depends_on "llvm"

  def install
    inreplace "meson.build", /^(cache_profiler_bin = executable\('cache_profiler',)$/,
              "\\1\n  install: true,"

    inreplace "meson.build", "__TARGET_ARCH_x86", "__TARGET_ARCH_arm64" if Hardware::CPU.arm?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/cache_profiler 2>&1", 1)
    assert_match "usage", output.downcase
  end
end

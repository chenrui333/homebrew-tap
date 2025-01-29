class ZigAT011 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.11.0/zig-0.11.0.tar.xz"
  sha256 "72014e700e50c0d3528cef3adf80b76b26ab27730133e8202716a187a799e951"
  license "MIT"

  livecheck do
    skip "versioned formula"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "b10a8a3deadab825aefa41ab283f0d18a6146786047499899ad8a6282737934d"
    sha256 cellar: :any,                 arm64_sonoma:  "e7e298ca1e2b3ab1d2ec0345d39bcc4cbcaf6aac758b0c9cce0c1be51b9f4c0e"
    sha256 cellar: :any,                 ventura:       "3e413f57aadd777e7d85620d6ed8b19905bad7b0e59a39a755e10393a06eccdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8cc9558cc39f3bef4476172245b5921d9fcb3c87f16f5f580ead41aa49e7db"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@16" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # `llvm` is not actually used, but we need it because `brew`'s compiler
  # selector does not currently support using Clang from a versioned LLVM.
  on_linux do
    depends_on "llvm" => :build
  end

  fails_with :gcc

  def install
    # Make sure `llvm@16` is used.
    ENV.prepend_path "PATH", Formula["llvm@16"].opt_bin
    ENV["CC"] = Formula["llvm@16"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm@16"].opt_bin/"clang++"

    # Work around duplicate symbols with Xcode 15 linker.
    # Remove on next release.
    # https://github.com/ziglang/zig/issues/17050
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # Workaround for https://github.com/Homebrew/homebrew-core/pull/141453#discussion_r1320821081.
    # This will likely be fixed upstream by https://github.com/ziglang/zig/pull/16062.
    if OS.linux?
      ENV["NIX_LDFLAGS"] = ENV["HOMEBREW_RPATH_PATHS"].split(":")
                                                      .map { |p| "-rpath #{p}" }
                                                      .join(" ")
    end
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end
    args = ["-DZIG_STATIC_LLVM=ON"]
    args << "-DZIG_TARGET_MCPU=#{cpu}" if build.bottle?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end

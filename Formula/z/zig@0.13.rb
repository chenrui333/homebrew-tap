class ZigAT013 < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.13.0/zig-0.13.0.tar.xz"
  sha256 "06c73596beeccb71cc073805bdb9c0e05764128f16478fa53bf17dfabc1d4318"
  license "MIT"

  livecheck do
    url "https://ziglang.org/download/"
    regex(/href=.*?zig[._-]v?(0\.13(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "bbea388227acb30d0806e1becafd1dc725d1d69f62a5c583636d9b7c7b1b0432"
    sha256 cellar: :any,                 arm64_sonoma:  "27c0769b1879727a949fedc3462f89ce1691121fdeecce5f70c00fde4ee0b60a"
    sha256 cellar: :any,                 ventura:       "5310c1d3312865c428a4de1793f56c59a5992981df0befdf269c84806f6a71e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4db2be3b77402bd7a78097ac80eafc1d6610820b278bfabd90edb081a5ba96cb"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "llvm@18" => :build
  depends_on macos: :big_sur # https://github.com/ziglang/zig/issues/13313
  depends_on "zstd"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # https://github.com/Homebrew/homebrew-core/issues/209483
  skip_clean "lib/zig/libc/darwin/libSystem.tbd"

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula
    if llvm.versioned_formula? && deps.any? { |dep| dep.name == "z3" }
      # Don't remove this check even if we're using a versioned LLVM
      # to avoid accidentally keeping it when not needed in the future.
      odie "`z3` dependency should be removed!"
    end

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
    (testpath/"hello.zig").write <<~ZIG
      const std = @import("std");
      pub fn main() !void {
          const stdout = std.io.getStdOut().writer();
          try stdout.print("Hello, world!", .{});
      }
    ZIG
    system bin/"zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")

    arches = ["aarch64", "x86_64"]
    systems = ["macos", "linux"]
    arches.each do |arch|
      systems.each do |os|
        system bin/"zig", "build-exe", "hello.zig", "-target", "#{arch}-#{os}", "--name", "hello-#{arch}-#{os}"
        assert_path_exists testpath/"hello-#{arch}-#{os}"
        file_output = shell_output("file --brief hello-#{arch}-#{os}").strip
        if os == "linux"
          assert_match(/\bELF\b/, file_output)
          assert_match(/\b#{arch.tr("_", "-")}\b/, file_output)
        else
          assert_match(/\bMach-O\b/, file_output)
          expected_arch = (arch == "aarch64") ? "arm64" : arch
          assert_match(/\b#{expected_arch}\b/, file_output)
        end
      end
    end

    # error: 'TARGET_OS_IPHONE' is not defined, evaluates to 0
    # https://github.com/ziglang/zig/issues/10377
    ENV.delete "CPATH"
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        fprintf(stdout, "Hello, world!");
        return 0;
      }
    C
    system bin/"zig", "cc", "hello.c", "-o", "hello"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end

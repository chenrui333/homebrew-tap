class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.208.tar.gz"
  sha256 "114b0a9fea1668d88c2a536be754a44a3710c24be30e41e7c5c97dd2226bcf2c"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "0b1cf2b3f1ad1bd7eb84bffaef661e35fdda61c3fe41695b44b88a74bfb0249b"
    sha256 arm64_sequoia: "029e5c88a1e0c9de139892cc6a0194fb9285db6da94ac894e986f2192e93c3dc"
    sha256 arm64_sonoma:  "fe42c1ce988b114d865d8cedaf69fce3a84a5bf6176bf4fda766a06d8fd5408b"
    sha256 arm64_linux:   "70778f16fe35b7f655410afd69d92b6a33a4bda773755ca791b69114ece4bcf2"
    sha256 x86_64_linux:  "1edf6e84bbe48840125426d3f0d8928aaac0662659a19f661e7810f3182bca6f"
  end

  depends_on "zig" => :build

  conflicts_with "nb", because: "both install `nb` binaries"

  def install
    zig = formula_opt_bin("zig")/"zig"
    system zig, "build", *std_zig_args
    generate_completions_from_executable(bin/"nb", "completions")
  end

  def caveats
    <<~EOS
      Run `sudo nb init` before installing packages with nanobrew.
    EOS
  end

  test do
    output = shell_output("#{bin}/nb help")
    assert_match "nanobrew", output
    assert_match version.to_s, output
    assert_match "nb <command> [arguments]", output
  end
end

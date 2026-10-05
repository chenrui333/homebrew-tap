class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.208.tar.gz"
  sha256 "114b0a9fea1668d88c2a536be754a44a3710c24be30e41e7c5c97dd2226bcf2c"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 arm64_tahoe:   "dcda3471b889fa0c1dd0d9db37b0a784c8b0114bd11b04f77b167152eef068ef"
    sha256 arm64_sequoia: "876ef73d147ef5ac2e35511cf48a9eee646de39a214b9d8b8f25c3e29170ec1e"
    sha256 arm64_linux:   "32b7d33f748b906c06b752573be466aaefcac41e5d2361d682a4ac6d6f3a466e"
    sha256 x86_64_linux:  "a611c4bc08fafa6e9b813531e65a6ac05d628d64884573b9a6ec4a8c108121ce"
  end

  depends_on "zig" => :build

  conflicts_with "nb", because: "both install `nb` binaries"

  deny_network_access!

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

    assert_match "unknown command 'not-a-real-command'", shell_output("#{bin}/nb not-a-real-command 2>&1", 1)
  end
end

class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.207.tar.gz"
  sha256 "a0aba0dab58e44978cf937005e92f5303c267954e33d6dba3e0eebec8c5ff2a2"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "285a4abdf6d7d814d1438bbc07ac1ffd37c4b42bfaff6fa8f0d15971cf464fb2"
    sha256 arm64_sequoia: "228bdcb2e05fe66f9dc06aee7ba2d2456bcc3f80166abc725588e0031a129850"
    sha256 arm64_sonoma:  "3dda4668b772acd75ad1f9325b065501a1de3c14a42475fc3f024fc80e0a96a2"
    sha256 arm64_linux:   "53040573f4fe4d8ac69c8a289bb721f7a9f969bbace4cf895b05b3746c948c45"
    sha256 x86_64_linux:  "d01c6d45d1aa5c79400b8bc7235ba0ef8a6b50981696a97b91ba7aba45007941"
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

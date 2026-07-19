class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.203.tar.gz"
  sha256 "106e0d09746eb56e1d97da33470d33eee180e8b8a76ad83306aaee6e99aff2f2"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "19a593032fd714acb141455e3940a7d18c3236123281c016cb46df35fc521bf2"
    sha256 arm64_sequoia: "e6b83b21a0198f2c8f5ae9445bfb09261d1871423c798d2845ab841d52a4567a"
    sha256 arm64_sonoma:  "586c85e6a8c4136e7c57d302f0923765dfa76da0d1583bb7c84d81b71448fc8b"
    sha256 arm64_linux:   "ca6f86d836bb78b8599395c55ed04b1e5478095f7daa789a62ab335b50e16482"
    sha256 x86_64_linux:  "a7dac1c4cb2671180c06116da29dbe36faa51925119525c79ece608536744c90"
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

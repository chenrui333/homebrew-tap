class Gitwig < Formula
  desc "Terminal interface for Git"
  homepage "https://github.com/tareqmy/gitwig"
  url "https://github.com/tareqmy/gitwig/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "8caf7db365702f6b5602b0ef92b9a97d9bc8ae77e01c3760db5d62d39beeddec"
  license "MIT"
  head "https://github.com/tareqmy/gitwig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "d2b6034a65fbe786054f2cae1c1537cabcb5d736e39e60f767f0ea51c00e817d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65744e765057f3ae73e3fb1406ce5877eef11dcd836ea4eaddc05bcc5029579d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48ba1e000d00948205d5b6b0be078b5758437792b4df0412e6d6a4c4fc738277"
    sha256 cellar: :any,                 arm64_linux:   "d160743e20a60755f0a6661a5c35751a50583a323df3977b955e03fc5843989f"
    sha256 cellar: :any,                 x86_64_linux:  "73300989e960b4e74e8b3394f7820b5c6d0c2ef08d1a6817bb75b8a48ee32be6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitwig --version")
    assert_match version.to_s, shell_output("#{bin}/gtg --version")
    with_env(PATH: testpath.to_s) do
      output = shell_output("#{bin}/gitwig 2>&1", 1)
      assert_match "'git' command-line tool not found on PATH", output
    end
  end
end

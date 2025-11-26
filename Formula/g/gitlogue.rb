class Gitlogue < Formula
  desc "Git commit history replay"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0e1733b19f8e7c43ef7051a92a3c6518bbb56ab6b42ed30a82b7c068e469d02f"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e6e9a17b954cf4dad90014a3fa14598680866b1c787a8aa3e688202d2a67d7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e610c5cde6c9f1f6fad97dd122b599bcb4fad047db488ee6ba48224eefac04f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0761563d31a1318bc0264567beffb8c45ef0bb188323d2c99a683c7d1e1eea34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a06a9f43433040b6b892b691d8b174e9cfb98f79579d213b297193567d23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38919d3fb66f19082f54750a8cf8fb977e5471705458bdbf2d66c2e3770ae7a8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")
    assert_match "ayu-dark", shell_output("#{bin}/gitlogue theme list")
  end
end

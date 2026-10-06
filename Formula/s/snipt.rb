class Snipt < Formula
  desc "Powerful text snippet expansion tool"
  homepage "https://github.com/snipt/snipt"
  url "https://github.com/snipt/snipt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a83d47c564e69c5805d4d99c3daa09ddee342d19c6df69f40e0fb6deb8647ade"
  license "MIT"
  head "https://github.com/snipt/snipt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f001f41702d9cd476f634dd59c830f56e2988ce50a27f69534bfb95bd940f25b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3e74119ccd3aa09a6a9d5e64840a48b8ed2b288aac76cb677a09bd4170ba36"
    sha256 cellar: :any,                 arm64_linux:   "9f8e0ae20cd0e6125ec4c3df8ea08a83b77cc089b98d29d26d5d5e289a8f6580"
    sha256 cellar: :any,                 x86_64_linux:  "fc9d423ff8b94569bbc8c6601d8c4f49390e533f9e6d917081022d346181a0ef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxtst"
    depends_on "xdotool"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/snipt-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snipt --version")
    assert_match "snipt daemon is not running", shell_output("#{bin}/snipt status")
    assert_match "Database not found", shell_output("#{bin}/snipt list 2>&1", 1)
  end
end

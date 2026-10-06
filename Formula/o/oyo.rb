class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "699f708f88173221ad51fe138082d54cea13f219ff70f737d817be9e8b9f5275"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e883bac64583fb1b2cac48ce4173a120509e57725d7549a366a0bd15ad1649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5d3b790480363d0363c7c4df9b5765e5c0abf356ec15623856f09473459d07c"
    sha256 cellar: :any,                 arm64_linux:   "3d667a08736959e01ef6b28eeb06a61042281032f68c71710947eb1c5b2f8707"
    sha256 cellar: :any,                 x86_64_linux:  "f5009c440961858677cdd7fdec59c0d9608d5cb629f2d7491fea7eee161fb719"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end

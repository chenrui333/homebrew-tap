class Ccboard < Formula
  desc "Unified Claude Code management dashboard for TUI and web"
  homepage "https://github.com/FlorianBruniaux/ccboard"
  url "https://github.com/FlorianBruniaux/ccboard/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a3f96b7c0dc7e33591d9ceed4c60172a40cec6de7ff00eda367adfd2f1a20166"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/FlorianBruniaux/ccboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13acd32f14c5c247d8e27a8d3dea440fa77aea5dd3dfdc4880cab828088d5761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c00537a9a2fa31095828b61b053abc6ecd9c622738e7ef07f29f13fa7b1583e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31709713ff0f2e06c223b2cd94f8c30da0f1f99e01bbc612e0d66577f1e2766f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3abcdcee57d4b3fb22f3aff26a1805df4fb6ffaaa19eda839da2af1efb865a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e52f7ba0201906cbe488e2caa75867f5aff183c8d4db14274c7a7fdf395f870"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ccboard")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccboard --version")

    claude_home = testpath/".claude"
    claude_home.mkpath
    ENV["CCBOARD_CLAUDE_HOME"] = claude_home

    output = shell_output("#{bin}/ccboard stats")
    assert_match "Sessions indexed:", output
  end
end

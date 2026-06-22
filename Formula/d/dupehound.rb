class Dupehound < Formula
  desc "Fast, offline duplicate-code detector with history chart and CI gate"
  homepage "https://github.com/Rafaelpta/dupehound"
  url "https://github.com/Rafaelpta/dupehound/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "246fa0af533f898ea5bd7ff403208485e52255da7d6bf166cd02cd658a86d738"
  license "MIT"
  head "https://github.com/Rafaelpta/dupehound.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c612449e82ac348841634418131643f0dedbb266ff0ab3688cdefb7371a7f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48e754d560346f8bbb4ff6b3ee4d615d9f01f6656b2f8dcecccd28e37d7209c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4dc2cb46a03dfccd7d2c14b952731ecc55387b126c07c0a8ba40a5ee6d7594c"
    sha256 cellar: :any,                 arm64_linux:   "7bb637338651047fb6d89de1acb9c3d12963aca81ca0a94f3063574563f921ad"
    sha256 cellar: :any,                 x86_64_linux:  "1a51078cbfeadc60716537e4a4014473608013563450c478a3988ad22fbf5cfc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dupehound --version")

    (testpath/"a.rs").write "fn hello() { println!(\"hello\"); }\n"
    (testpath/"b.rs").write "fn hello() { println!(\"hello\"); }\n"
    output = shell_output("#{bin}/dupehound scan #{testpath}")
    assert_match(/duplicate|clone|pair/i, output)
  end
end

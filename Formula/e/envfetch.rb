class Envfetch < Formula
  desc "Lightweight cross-platform CLI tool for working with environment variables"
  homepage "https://github.com/ankddev/envfetch"
  url "https://github.com/ankddev/envfetch/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "f98e8bac25069830383a594bb7ab3f85b262ef04191e11384791a475aa70f85e"
  license "MIT"
  head "https://github.com/ankddev/envfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73aa8029cff4e67888ba761fc80b5204fb2e7ef905f3f1a36a33493752d0d838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d12181141e0ce1792390321e2738a3357143db0382cd19b88dfca86c5c2e23ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c056721adce7c3a9644bbf5e6346bca12485e7c3b6f1f40c52a1321ad568a96f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37ef063ffaa7aad13e64861b0ae2b73340e47b0f24f82a6d48a51b0e3c273c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574ae5b625012e04dd8444fe7e12a0b275c0b4d251a0541b291f32ee76a386bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envfetch --version")

    output = shell_output("#{bin}/envfetch set TEST_ENVFETCH_VAR brewtest -- env")
    assert_match "TEST_ENVFETCH_VAR=brewtest", output
  end
end

class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.24.tar.gz"
  sha256 "0be91ce2ecceeaebcd40926b3c78f4867c056b93615c2a5ff01b4578d1f4b9dd"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b7f8e38db853ad52d347c739c4b4bd89679e3e11bd2aa0fca9feea10c34b787"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c97dd2db88ab77414f1369eabaef636c535b1c58a2e58aae17190089e5b8d01"
    sha256 cellar: :any,                 arm64_linux:   "28a892e86d65e066b508bcf1a4239a98f06707e50f010232ae8276e165843242"
    sha256 cellar: :any,                 x86_64_linux:  "585c5e5baa4c186b4bb93fd2e0f996ddd27795aaf1bc1292d605266079f0f7bc"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end

class RsPoker < Formula
  desc "Poker evaluation tools with hand ranking, enumeration, and agent arena"
  homepage "https://github.com/elliottneilclark/rs-poker"
  url "https://github.com/elliottneilclark/rs-poker/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "34ec8fef9411e3e9d3b8fd08c004a379b7080709a8e3db08f80fdd59b4f9826c"
  license "MIT"
  head "https://github.com/elliottneilclark/rs-poker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da4fd5ac9bdcf8d75f7f294c7536c57bd6f4f733a1da7f3df4dd4e6225bd41c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8d633739f5fc007d65df4ecf9e0a8f3ee5825397814a1a43491cd09ba9d0681"
    sha256                               arm64_linux:   "f9421c60fc76e3b28a7f8bee16f332b734198f35b697db416137aecd9c72ebb7"
    sha256                               x86_64_linux:  "a53f988a68ba980ff391232c58cf6f3f4e10427a451f9b90deed1e4e6260b448"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "rsp"
  end

  test do
    output = shell_output("#{bin}/rsp --help")
    assert_match "rsp", output

    output = shell_output("#{bin}/rsp holdem --help")
    assert_match "Hold'em", output
  end
end

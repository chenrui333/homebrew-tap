class RsPoker < Formula
  desc "Poker evaluation tools with hand ranking, enumeration, and agent arena"
  homepage "https://github.com/elliottneilclark/rs-poker"
  url "https://github.com/elliottneilclark/rs-poker/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "34ec8fef9411e3e9d3b8fd08c004a379b7080709a8e3db08f80fdd59b4f9826c"
  license "MIT"
  head "https://github.com/elliottneilclark/rs-poker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bbf8d0e05b1830133003e0c5dd60be45f161a8a5da7d49a3f521ce18a483a05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a2ff687baaa5806eebe7c0c0d94b692436da070b6f52b3c1dda406186bb9b71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc3fddfed8ea54ff25c8f0d92dac86dfac8ee1e1a3d32af1dd1ffd36580188a"
    sha256                               arm64_linux:   "d5b3451cd448a398135e059dc9a544ef54a26da3297007bfe3c87e913a5c96af"
    sha256                               x86_64_linux:  "b9605245654a37d1b4600169bc03f49f055a250a97c1c7191ade035a485f67e7"
  end

  depends_on "rust" => :build

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

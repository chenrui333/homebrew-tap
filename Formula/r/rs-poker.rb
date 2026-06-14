class RsPoker < Formula
  desc "Poker evaluation tools with hand ranking, enumeration, and agent arena"
  homepage "https://github.com/elliottneilclark/rs-poker"
  url "https://github.com/elliottneilclark/rs-poker/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "ea1d4f92ddbc27a58f6559ae26e0777d8f8b64b476c2f3573c1cf49847b03a45"
  license "MIT"
  head "https://github.com/elliottneilclark/rs-poker.git", branch: "main"

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

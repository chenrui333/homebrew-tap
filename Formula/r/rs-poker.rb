class RsPoker < Formula
  desc "Poker evaluation tools with hand ranking, enumeration, and agent arena"
  homepage "https://github.com/elliottneilclark/rs-poker"
  url "https://github.com/elliottneilclark/rs-poker/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "34ec8fef9411e3e9d3b8fd08c004a379b7080709a8e3db08f80fdd59b4f9826c"
  license "MIT"
  head "https://github.com/elliottneilclark/rs-poker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd15038f0d26525789a71695a84ef0b31f350ec9c98a0b4c3c367dfcb1723987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e83e12fb9637a5bf44635b9eca3ea9e77749ee7e63b6034d63367b664674c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88815195ec57ae11463f3390838c74d8d3e98541641d61c80af256840dccc0f6"
    sha256                               arm64_linux:   "c8e1b42c8bdd31eae6dbc34194358e6d68d58763ef371d4bf4c5ee55091bd928"
    sha256                               x86_64_linux:  "2657aa43db60db02757fc5e49aaf9bdbcbfe4a63ccdfc5c7112c75d38de2f052"
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

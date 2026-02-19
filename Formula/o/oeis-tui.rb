class OeisTui < Formula
  desc "TUI and CLI for exploring the On-Line Encyclopedia of Integer Sequences (OEIS)"
  homepage "https://github.com/hako/oeis-tui"
  url "https://github.com/hako/oeis-tui/archive/refs/tags/1.0.0.tar.gz"
  sha256 "68bd20b731e17ef54708f7c26cdc901488e0948056bd5d519e16fd720f3c0d58"
  license "MIT"
  head "https://github.com/hako/oeis-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d222e916ffa8f58a6f2219073c74fd37bedfaf733f7665886b35be21be8bd7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5fd2e917bb3dcd0a55cdf7cb93affac8f32ccc6aa329b5391fc396bb60be48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b0846d4e523589ee1b7076983c671fd9dee20a23cfbc74599e33dbfd1910e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b92fb1aa8835daabb51a90476beb4fa4299ba0ac056586dc12a6004ad5e9652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f24df548103ce53702886ec909b26c130d5617b25c397ff91c24e8005fc7d5c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oeis --version")

    output = shell_output("#{bin}/oeis fetch foo 2>&1", 1)
    assert_match "Invalid A-number format", output
  end
end

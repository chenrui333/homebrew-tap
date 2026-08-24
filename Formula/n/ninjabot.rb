class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b5068dbb125d423956857cd0e73aa4c8df6b6720dfece9caff4dcd3c120d1685"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32ea1b5db85c9d67809187f29d6ddaaad5a95ba99e1f3a6e2bec10e343a2ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d32ea1b5db85c9d67809187f29d6ddaaad5a95ba99e1f3a6e2bec10e343a2ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d32ea1b5db85c9d67809187f29d6ddaaad5a95ba99e1f3a6e2bec10e343a2ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1e22029748b10afada2f365894c16cfa9dcfda8fddd1eda9fed9fcbfc8f0794"
    sha256 cellar: :any,                 x86_64_linux:  "67b21f81d70a83ab102414c21e4ae426ad9e96b286bee978a21de58c18e7f7ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ninjabot"
  end

  test do
    output_file = testpath/"btc.csv"
    output = shell_output("#{bin}/ninjabot download -p BTCUSDT -t 1h -d 1 -o #{output_file} 2>&1", 1)
    assert_match "Service unavailable from a restricted location", output
  end
end

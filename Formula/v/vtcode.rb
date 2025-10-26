class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.34.0.crate"
  sha256 "609c9fd2a73a4c94fd05b458e83e7441de67cea9efe96adeb2e76527b16f4450"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14164333686dc2ed14b496cb4a7cb1c63b87d08d5af2f8ae8c45596a476bd04e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e2ae11b420b171c13eb3ee8777dc5abfcc5f9c3ab5edd11d8a537d9ce98ed6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5baba72cb1bdf7818d51865a012ac0d2273dee41f24f0e707f5eb1829c88d9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3edfe17d2eaeb357748c9ebcbfc7ba3fd1de28dc4cf9a56711e609450b4adad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99497e8291ed1bcea1e654349cfe0a72b340cd612dc4388d72646f277f155ae4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end

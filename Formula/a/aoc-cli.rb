class AocCli < Formula
  desc "Advent of Code command-line tool"
  homepage "https://github.com/scarvalhojr/aoc-cli"
  url "https://github.com/scarvalhojr/aoc-cli/archive/refs/tags/0.12.0.tar.gz"
  sha256 "5bd2eef8a310564c122be34ea9116967fe887ea549146adf38f4fbb0cddc0539"
  license "MIT"
  head "https://github.com/scarvalhojr/aoc-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c19053f68761ab056c7c5031ffa487b6f314acdcce2a6a000becb638950586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c9e38392799aa1d216333e5cd8f6354a54d08c225f0cb70f091eb57f3c5b8e"
    sha256 cellar: :any_skip_relocation, ventura:       "a85befc69f944e03bb6ae2e0527c924da751ffafb5ebda901155eda49005dd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c9cc39374bc6d3947584111683f697223909b16d12551a069df53fc8b3517f"
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
    assert_match version.to_s, shell_output("#{bin}/aoc --version")

    output = shell_output("#{bin}/aoc read 2>&1", 66)
    assert_match "Session cookie file not found in home or config directory", output
  end
end

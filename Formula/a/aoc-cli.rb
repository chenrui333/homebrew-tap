class AocCli < Formula
  desc "Advent of Code command-line tool"
  homepage "https://github.com/scarvalhojr/aoc-cli"
  url "https://github.com/scarvalhojr/aoc-cli/archive/refs/tags/0.12.0.tar.gz"
  sha256 "5bd2eef8a310564c122be34ea9116967fe887ea549146adf38f4fbb0cddc0539"
  license "MIT"
  head "https://github.com/scarvalhojr/aoc-cli.git", branch: "main"

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

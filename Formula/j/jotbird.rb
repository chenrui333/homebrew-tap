class Jotbird < Formula
  desc "Publish Markdown from the command-line"
  homepage "https://www.jotbird.com/cli"
  url "https://github.com/jotbirdhq/jotbird-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "11041b85960253f6aece2f14e9a735182d039df043d5c43415035867d3391036"
  license "MIT"
  head "https://github.com/jotbirdhq/jotbird-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "fd238b4e71fd52278ca841c9764456aad13a53102fe067916fa1f218d249a863"
  end

  depends_on "node"

  def install
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/jotbird"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jotbird --version")
    assert_match "Not logged in", shell_output("#{bin}/jotbird list 2>&1", 1)
  end
end

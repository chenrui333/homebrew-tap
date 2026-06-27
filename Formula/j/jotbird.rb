class Jotbird < Formula
  desc "Publish Markdown from the command-line"
  homepage "https://www.jotbird.com/cli"
  url "https://github.com/jotbirdhq/jotbird-cli/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "755cfeca2b1820c9bf290d5b23cca678184a3e24998b8f3999b6c157be28f709"
  license "MIT"
  head "https://github.com/jotbirdhq/jotbird-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ffd458ab444933b20241bb0e1f61758eb9e8812370a2a039a26eecb029987b56"
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

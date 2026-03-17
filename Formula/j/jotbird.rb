class Jotbird < Formula
  desc "Publish Markdown from the command-line"
  homepage "https://www.jotbird.com/cli"
  url "https://github.com/jotbirdhq/jotbird-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4ebce509e141f1f74dfa0ce48e6060bd3eedc3d23c4ff0b9778e297c68efc9af"
  license "MIT"
  head "https://github.com/jotbirdhq/jotbird-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ad14a012e238766ba2ed15d2e2b73213078ddade4a94f7e5cc0d0c24c906b5a6"
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

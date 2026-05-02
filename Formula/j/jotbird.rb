class Jotbird < Formula
  desc "Publish Markdown from the command-line"
  homepage "https://www.jotbird.com/cli"
  url "https://github.com/jotbirdhq/jotbird-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "dc6cd63d74e62eb9f8bbfc2e8c4eaef9878ef1cfaa2ea4c725cc32a92c66aa96"
  license "MIT"
  head "https://github.com/jotbirdhq/jotbird-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "3543edca1c50bf3d7d8e84e347c602480d0226186dbf41b6599153ee075e71fa"
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

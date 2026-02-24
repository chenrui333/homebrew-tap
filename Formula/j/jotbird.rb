class Jotbird < Formula
  desc "Publish Markdown from the command-line"
  homepage "https://www.jotbird.com/cli"
  url "https://github.com/jotbirdhq/jotbird-cli/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "61c9614d29af408738469bb66ef8798e4b219fcea8a71a32a890eaad888349a3"
  license "MIT"
  head "https://github.com/jotbirdhq/jotbird-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a9fddbd701e975ea763850a65630afb885f8498588680fdab48afbb2966aeb06"
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

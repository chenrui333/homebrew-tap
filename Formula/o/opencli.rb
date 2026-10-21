class Opencli < Formula
  desc "Make any website your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-2.0.2.tgz"
  sha256 "5f5c956252c5b988c4d305fcb04637ed9d9ecda251d555ffb18fc3734e1bea85"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1ba63a2b1be86acc62343549bb2840259212149b196611cdd31b6f6b03fa3359"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencli --version")
    output = shell_output("#{bin}/opencli --not-a-real-option 2>&1", 2)
    assert_equal "commander.unknownOption", JSON.parse(output).dig("error", "code")
  end
end

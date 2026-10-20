class Opencli < Formula
  desc "Make any website your CLI, AI-powered"
  homepage "https://github.com/jackwener/opencli"
  url "https://registry.npmjs.org/@jackwener/opencli/-/opencli-2.0.1.tgz"
  sha256 "eb41ef9804efce3711a4f026c04e4fd42c922b47161d0f41388ffbc2caa87c9a"
  license "Apache-2.0"
  head "https://github.com/jackwener/opencli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4b64e5a3fdae95a380892ec6213c59b589220e77db0827d1a4161e545a03ff87"
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

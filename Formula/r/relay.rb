class Relay < Formula
  desc "Simple tunneling with random 3-word subdomains; a self-hosted ngrok alternative"
  homepage "https://github.com/talyuk/relay"
  url "https://registry.npmjs.org/@talyuk/relay/-/relay-1.0.4.tgz"
  sha256 "ca49e43fe8f334a037448ab8bdcc7bb0351aee7fceebc9eac8fde6807be2049b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4f6e5c5a5d31928598490d37c12a32039ded3a4e34e0c7d6adddb304198526ed"
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
    assert_match version.to_s, shell_output("#{bin}/relay --version")

    output = shell_output("#{bin}/relay 3000 2>&1", 1)
    assert_match "Server hostname required", output

    output = shell_output("#{bin}/relay notaport --server tunnel.example.com --secret your-secret 2>&1", 1)
    assert_match "Invalid target port: notaport", output
  end
end

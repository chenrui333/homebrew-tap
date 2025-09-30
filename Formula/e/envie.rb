class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.14.tgz"
  sha256 "567e1ab812dfd1292e6f5daf173b636fe544da608171f46d0378c5f3e2be60d8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb533bd2ac670aeeaf9aeb51d465e468bf093faf7dc5fad7d8f66117d3b93e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13389aeac17f44b95b3e33c49a7695c1228c357a35d79881e53968220b2d410e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c11cc0559cf278841380fea2fd7badd4defeb9ba7d4229377d5b1b3fd67d71f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Error: No authentication token found.", shell_output("#{bin}/envie environment list 2>&1", 1)
    output = shell_output("#{bin}/envie login 2>&1", 1)
    assert_match "Login failed: Please specify which keypair to use", output
  end
end

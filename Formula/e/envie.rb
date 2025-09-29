class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.13.tgz"
  sha256 "9f2e49556a3dfc186fcd4d0bb572496d4c38b3a93dd2be33956394f11ab55d2c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b3d0f47c5093364c2f3ad50ae13d83f0ca84c54c78137bd97b2463553b1685a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a785eb2ccdcef913064de914a3cf7c5f49943bf8e72a0cfe578607f66f9f05db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58dbaf3ef449d6e17bb8df28ab19b84a3f2e3b65d4211ffb5e25216860d6f733"
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

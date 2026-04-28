class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.7.tgz"
  sha256 "a55785d2739866b49adb95b9d33e6f9e78418e870f07bff978665019a5a60292"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1810cca1e07d35cc55e2043288c804fac57f5e6cba4c5ee9afa0e39e2b526d4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1952631aec4c932b54b18fcbd7fda81b47e6fa25a55e9efb3c132527ce2102e"
    sha256 cellar: :any_skip_relocation, ventura:       "3350cb62f8f3ff66c8f01742d0f1fb954d8ec2e1d1c4bccd3361fa1f93c6ec4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747aab611d680936152b509ddd30f6c94d83cf024761cc9127dcd86eb76a24ee"
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

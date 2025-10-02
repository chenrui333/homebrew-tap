class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.1.0.tgz"
  sha256 "9516e0e6e14476a8433388e4ffad47960cb1c00c4522dc6c1d97570a33e3f0aa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b867ded9668847d7addbcbbfe34eec3be7d4060be92cb478a4bad8ce70858721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd5e08b521eba67f352bce907dbd5338854b2337869a8dd463331123a10ceff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16e227c57ad8e9ad96bb5f6c4d700ac9d0be3fdee949b8e5808ccf0aa199cc9"
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

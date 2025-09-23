class Envie < Formula
  desc "MCP server for Apify"
  homepage "https://github.com/ilmari-h/envie"
  url "https://registry.npmjs.org/@envie/cli/-/cli-0.0.9.tgz"
  sha256 "5ab20f4ca1716cdd9d4970a6bf8b3524449879cf7ecc6fe1587cc9f364ebaa3e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0bd9ee031f45570766c2059a15f20990948985909c86a437ca14931a35db870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6db932062c1c3989ebdcfdcc294954ac345126d6b1ab19f0e6ce3a037156deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6c83d879ae26f69638ede55deba0c0352b1fd87c65916826647dc097a7ad8e"
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

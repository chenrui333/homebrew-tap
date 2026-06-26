class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.4.0.tgz"
  sha256 "5a14e2f0b39cf552cbaa0eeb10acc96d3dcb508ad26aa01e590ba2f7da55f0e2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4f137d45985f20e7536aa16e6bd1f27020a303b0b0d6997edd486e91ae109663"
    sha256 cellar: :any,                 arm64_sequoia: "875c1832dda29baba4d289eb7f4cd00e3820b829b502ecd00c3548f0ed481876"
    sha256 cellar: :any,                 arm64_sonoma:  "875c1832dda29baba4d289eb7f4cd00e3820b829b502ecd00c3548f0ed481876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b1fbbc2ff5fbc7c2d37d83cec11fe6d94b04fd1f999517ae9d23cf4540e475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96f27980599c3f244f34ddb319e062655370549f73205e64db2225ef5a8f0a21"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpc --version")
    connect_output = shell_output("#{bin}/mcpc connect https://tools-list.invalid @test 2>&1")
    assert_match "Session @test created", connect_output

    output = shell_output("#{bin}/mcpc @test tools-list 2>&1", 1)
    assert_match "@test", output
    assert_match "tools-list.invalid", output
    assert_match(/Failed to connect|Connection closed/, output)
  end
end

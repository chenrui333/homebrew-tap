class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.5.0.tgz"
  sha256 "ee1643c28ff1d3dc3945cf44679cb8d97e7d03439db7383df8f8fb5d530ad3b1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3bbe5b430636733ac97499674812a85ad48fadc0289afb9961bf655e43435947"
    sha256 cellar: :any,                 arm64_sequoia: "3bbe5b430636733ac97499674812a85ad48fadc0289afb9961bf655e43435947"
    sha256 cellar: :any,                 arm64_sonoma:  "3bbe5b430636733ac97499674812a85ad48fadc0289afb9961bf655e43435947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d8f09f4115eebfcdc1ba31d22f459e831399dbf5c1864de7500583cc03fd94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cce47ae9ed1d2c4e72a3e68af6d745926680bd575736ba21fcd7f088759d5e"
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

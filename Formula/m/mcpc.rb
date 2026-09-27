class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.7.0.tgz"
  sha256 "f5a99edf633089474e3ca1dbd928c560eac63f1e8a5ff2d6f048b92d0cd4da8c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ed38ec3ded717581875db1310accaba27da0973a47ca5f4837c11d4747af4a2d"
    sha256 cellar: :any,                 arm64_sequoia: "ed38ec3ded717581875db1310accaba27da0973a47ca5f4837c11d4747af4a2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d677665b88019221f847bb85066012130073d707d3a8c4c633b9cd9fa8a21b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0231c5051ddf40c27a9a1fc16e2fc39b7d7914e0afde15851ea245b1327decde"
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

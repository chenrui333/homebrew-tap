class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.3.1.tgz"
  sha256 "32ce9cd4d343899ca8742d1747f93f0e9e5802806a891f32c50ebb7f9c73c710"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "18bdf4abb53b51081b42710c2734ed69c046203cadc7f9eb3139b82f6711b3dc"
    sha256 cellar: :any,                 arm64_sequoia: "0c1c4a4d5cc2ff5a02dbdf62d2f30e66c92666662068099c2d3d7a306b207034"
    sha256 cellar: :any,                 arm64_sonoma:  "0c1c4a4d5cc2ff5a02dbdf62d2f30e66c92666662068099c2d3d7a306b207034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ad29237c2a7bb13f21577b6c647db86489397eb364985bba0cc27330682f92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61caac45e12671cbdce4cc6304b5a01cae959917e8ec814c2d5cd3d8bffb906b"
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

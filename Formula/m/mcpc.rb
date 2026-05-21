class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.3.0.tgz"
  sha256 "dd70c23bcfb018443131d247e1a6a544d3a78be8cc81f9ed633e3c2f99ceee11"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0900ec797f21e2b71844bd9af00718bddb70f2e95f849ed5c0ed506d36589ffb"
    sha256 cellar: :any,                 arm64_sequoia: "d9052bf31fb71b837bb493b4d3a610acc0141e3cb14417fded1277eb4641534d"
    sha256 cellar: :any,                 arm64_sonoma:  "d9052bf31fb71b837bb493b4d3a610acc0141e3cb14417fded1277eb4641534d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "041b563d09ab9092c33bada7b59bcdbc8af4cd8bff3e5a175c3c38c885a28ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efd7316bbb43e93292ef957d9b331c52f951471c3846ca444a3bbc8a15c7235"
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

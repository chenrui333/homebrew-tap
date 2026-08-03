class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.6.0.tgz"
  sha256 "06be88bfebf27124615abf0dab4fb3b956c5ae8a1dd7e482c434ab891564dfd6"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "428b989face5d8323661bfc4313e426acbd255389ef288d16a8e7137f77968bf"
    sha256 cellar: :any,                 arm64_sequoia: "428b989face5d8323661bfc4313e426acbd255389ef288d16a8e7137f77968bf"
    sha256 cellar: :any,                 arm64_sonoma:  "428b989face5d8323661bfc4313e426acbd255389ef288d16a8e7137f77968bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4050fe809d56e1d4572c4ae958010cad3c3c25cf3435a1322fdc13d692d17e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ad79f2b9104cd013cb1cae016fa8266367610095834a7049ad2c80a77ce5bd"
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

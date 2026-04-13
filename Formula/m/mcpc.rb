class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.2.4.tgz"
  sha256 "aeb855bf09cbd4c8142332378e304c80f3943db198d512ea1216becb1e93ae0e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "992a85125001ecd67cff965de5f9a9f9e73c8e76abeb2c3b6cbf984f92285dac"
    sha256 cellar: :any,                 arm64_sequoia: "dbb0b524156b15e74e2486d3aa549809198678d1f2c96d3c5296751429ca5260"
    sha256 cellar: :any,                 arm64_sonoma:  "dbb0b524156b15e74e2486d3aa549809198678d1f2c96d3c5296751429ca5260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a66d3a55dd966a8bfef6ad02d742a8ac4632cbee9b5b04d9ac8243631d018c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65cdfbf5f22efb24baeb306b7e08b5197fabdd7077e4933a682e7ba766c6faf5"
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

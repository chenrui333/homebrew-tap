class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.1.9.tgz"
  sha256 "bbbac55cb86970d506357fa3c1eba32161eefc7a48a64e202e9ee8778862aeeb"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "13fb18dee710fde64070234d370f3cc8255db655f4c05fcf3dac5c04a038114a"
    sha256                               arm64_sequoia: "12f35f79c285e473add2429f34582338c425d1f38082f3f29203fb45f0e698d6"
    sha256                               arm64_sonoma:  "27c0b98c45b9697982ec7605a07ef391956b9cb389f179ea138897cca240ef2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f611145dbd61535ebbc88be99eb4f622f6748d54e6dcd79ed2dba21b3355eb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f92c5eb753d9a6a9341af19421432fb4c6c473b4749ca98285e9e231e4afd43"
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
    output = shell_output("#{bin}/mcpc tools-list 2>&1", 1)
    assert_match "[McpClient:mcpc] Failed to connect", output
  end
end

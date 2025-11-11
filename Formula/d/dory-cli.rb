class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.29.0.tgz"
  sha256 "09ec03aed11e66d7c573fb86fb86d42761b43cbd4b110dc7039e079ba51b23c3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8bb8a5319b51b3ebc953dfa63f916823349b01b1f42252845a5e204aee13aaf0"
    sha256                               arm64_sequoia: "b2ed2ec1fce1228f68d257473ad2c957f85094dfe0da34f8116280d570f14234"
    sha256                               arm64_sonoma:  "d884d9a2509ad471f7a1141b16cdd39c9206b29a37ce4b2e7754bbe838f3fca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "892221e67bfc03639c13e0bfa487e3a93556ab9ab599838c20f99fc00c308212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679743a6f55e532f6a7e4fbbbffab7aea1710db4bef12945cc7e7a1f28ab4486"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    if OS.linux?
      (libexec/"lib/node_modules/@clidey/dory/node_modules")
        .glob("sass-embedded-linux-musl-*")
        .each(&:rmtree)
    end
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end

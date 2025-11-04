class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.24.0.tgz"
  sha256 "1456f4c598862430d6a41d8e3a1e0a4682ca620f3c075b61dd41e29409142199"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "32d303b0f883ecbf3d59bc60361c648b89aba2133ac86eb0eba946206a9c8885"
    sha256                               arm64_sequoia: "24c04be17284968d50bc1918a9b3545dd0bd8f70ca1fa742b95a41d0197e9702"
    sha256                               arm64_sonoma:  "13b8f1a2916de78af8f96a74ffa9fadbc7447bd06ae198aaa29f8d69e7b91872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a0fc5ef05b7273a15224259903cc86e0f920f5952c99a78c60790e9809c3f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f9c578504780a2e86a90937005962218ad8da41325386bcb6f3d8853fae190"
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

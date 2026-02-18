class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.39.0.tgz"
  sha256 "681f5011c2c60ce66f72e18afb9be8ccdc9e1ba0ea550843b980b642f98d5951"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9fa9bc61f553c0250f2704cc7e929ed7168bb525b9a80fc4d7ab293ea66f5ef9"
    sha256 cellar: :any,                 arm64_sequoia: "e57de36690bd970ae910bd8f44b4b20eb445e047ce6a5d45fdf0c8f75c83991e"
    sha256 cellar: :any,                 arm64_sonoma:  "e57de36690bd970ae910bd8f44b4b20eb445e047ce6a5d45fdf0c8f75c83991e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef0ef55099baa9d6f8eb7a1d9c69d297886ce41d54b06fe467e2517abf389675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9190159472000260b1b67ad0b7ac082ff2ac59be1a7ca468d111da250dbd474"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

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

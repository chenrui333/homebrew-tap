class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.22.0.tgz"
  sha256 "d96516a382ae81c6fcddbc2db42e5af979d7ba54cd66433576ddd20900047011"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "bcde0f63e7d71481c4f00691b281597e2e6ae47e52496ec589b23dcaf80deb35"
    sha256                               arm64_sonoma:  "1aac38bb75cfc9917daac4ba7abcf34ec2832da8ae2a13444b97e1b0c53d7b97"
    sha256                               ventura:       "148c0b357acef90ca4dcdac4337bce185201d29d2584cc2176e1795bfd151d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14521299192932117d34d3c84525426c175e3c3d47a5cbf6d503d7451458f62"
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

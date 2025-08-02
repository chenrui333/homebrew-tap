class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.20.0.tgz"
  sha256 "78adc10d611ec60fc1b8a6645845d222d35150855401375becc249c4268fabd8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f18c99a6a5ea512fe9ca610349077db71257965fa492965a9b93d73fb8c22aa8"
    sha256 cellar: :any,                 arm64_sonoma:  "e19aefddce5da5f91a0ee6627c1bd54cb89cf02dc3d7ebcb449f820b9c3cefe5"
    sha256 cellar: :any,                 ventura:       "945c26aeffa403df1d8f06c26675245c64b934164d6627f205a3360abb23db84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5766ed458a7e0aa7b737b737b1421600fd8c8a6ab11c977bf6d4faad4335b832"
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

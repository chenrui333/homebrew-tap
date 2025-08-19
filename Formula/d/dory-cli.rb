class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.22.0.tgz"
  sha256 "d96516a382ae81c6fcddbc2db42e5af979d7ba54cd66433576ddd20900047011"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "b5863e5152ae7df9428ffeeada73533ee903c7a7f73931887f5327aba32c2dcf"
    sha256 cellar: :any,                 arm64_sonoma:  "fea687de0938b2debcd51399a412089fde9ed7b485ea66f6c0d237181fbf0e8b"
    sha256 cellar: :any,                 ventura:       "83f9cd91c9b93a0cff7042cea75eefe86b1dda280d417b07c42125a719428970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad6e5781dc5fc1a08384707a7b3a84578a36f8c1111f4dcc9ba64331f761710"
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

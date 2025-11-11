class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.29.0.tgz"
  sha256 "09ec03aed11e66d7c573fb86fb86d42761b43cbd4b110dc7039e079ba51b23c3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "61d8114416e7221ad27a5c653827cb56fce20ce3030e407eb83b13a60b83cfd5"
    sha256                               arm64_sequoia: "2ed5fd40b6abaf2437b56b95de01d93641620366c883996eba1f7a46890c783b"
    sha256                               arm64_sonoma:  "45c98d6aef54dbc7926b7ac20f193bcf3b59070017b7491a8b69a8e68e57ce97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da15c03e2a7133876248f19b9efa721e6670b9f1c7a98268c457a8700c102cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d659d7fc04d865b28dc5dc6a50391437a76368556d047df707859120b4ab86"
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

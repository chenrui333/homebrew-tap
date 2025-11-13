class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.33.3.tgz"
  sha256 "6b030f201639cf456a1cc639694c2683359821d56d32078347ab399ac39ad49e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "14d1b99be024ebc2450ccebbc54786a828abbbb8845637e81d2fd3e90d3314f5"
    sha256                               arm64_sequoia: "413147a5fa83d8a7c960ff79a6c7ae0d466d6ca42bf6229173242a2284410a13"
    sha256                               arm64_sonoma:  "fc53b8777097d96ecdfba57bbbba0cc6bc5b25da5c2661b221945552c6f9d075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b772573d0bf3689135b9b1081875c88a3cc9bcd485ee6b4f2a2a8f17c3cf871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c3f4f2a2e15717b7d352453bdbb6dd633b84cbc45895a05150eafc7669f7bd"
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

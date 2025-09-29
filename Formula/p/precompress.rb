class Precompress < Formula
  desc "CLI to compress files to gzip and brotli"
  homepage "https://github.com/silverwind/precompress"
  url "https://registry.npmjs.org/precompress/-/precompress-13.0.2.tgz"
  sha256 "2a219c1de3db8ebc7f2c415885ef1c72a3cebea06626f1f743f109a17f070f24"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38cf73628fe4ff86b7b2bfddc1dcd0e5480256c751cc50adca1649d83f7c6ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ec8769855f36c7c2ed381eadad1ad5c5013eff64fcff44cfbd1020b084c7edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a7c03b124ad36ca59ca907796b17bc7e7e96f92316e02c90977339c47863837"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/precompress"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/precompress --version")

    (testpath/"test.txt").write "This is a test file."

    system bin/"precompress", "test.txt"
    assert_path_exists testpath/"test.txt.gz"
    assert_path_exists testpath/"test.txt.br"
  end
end

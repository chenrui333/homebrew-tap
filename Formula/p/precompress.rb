class Precompress < Formula
  desc "CLI to compress files to gzip and brotli"
  homepage "https://github.com/silverwind/precompress"
  url "https://registry.npmjs.org/precompress/-/precompress-13.0.2.tgz"
  sha256 "2a219c1de3db8ebc7f2c415885ef1c72a3cebea06626f1f743f109a17f070f24"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03df9ed6f9845b5304b58c5e7e561b63d2c6e760de16a601def93408dca3e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9651fed2931b201f0e9b740a469c6645dfe1c9c188112e296d750ae6622310f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd52fce51f5ddcf58033efdc1fb971314d7b84be933429c0dede4cb3c2c565b"
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

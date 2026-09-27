class Precompress < Formula
  desc "CLI to compress files to gzip and brotli"
  homepage "https://github.com/silverwind/precompress"
  url "https://registry.npmjs.org/precompress/-/precompress-13.1.0.tgz"
  sha256 "a7acd17aab028a8b4fa0f5a7e3c5d61cbeef63cc72398dd02ffe3434f546e370"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "279017a86b7d0c589dd392d662349b6fdd34ce340006d77f50c6d640dc90350c"
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

class Precompress < Formula
  desc "CLI to compress files to gzip and brotli"
  homepage "https://github.com/silverwind/precompress"
  url "https://registry.npmjs.org/precompress/-/precompress-13.0.1.tgz"
  sha256 "437f70b6df157a191b2235da4606996aa03750f6ac3ff55ab713b8c7a3f46db4"
  license "BSD-2-Clause"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ab76bb0926eba633db6dd341b2358cc2245508bbe103a575e3b1c8aadac45e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "042950002d42207a4ff4e168e75eb5593b3f3d1958f5e2da15250f00fffa1a9b"
    sha256 cellar: :any_skip_relocation, ventura:       "c73523b6a33fe64ba741f84e21d0b24f941f9bb9200fcd76a466ff663e84f12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62cfe4711d98fe51c915dc33920c4585bbb557415cda9e979871c2bfc85a1a7"
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

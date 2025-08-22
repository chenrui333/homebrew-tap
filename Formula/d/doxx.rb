class Doxx < Formula
  desc "Terminal document viewer for .docx files"
  homepage "https://github.com/bgreenwell/doxx"
  url "https://github.com/bgreenwell/doxx/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "6923cefa432a08adacedeb105902d47858f0ceea51b00e21e8b10117d86ca9e6"
  license "MIT"
  head "https://github.com/bgreenwell/doxx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82ed0e4f49a339e07fc79fa60002623c2f4a3150d539bd3bc059aaf6700e4b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66edfa3de70b54cf136f9794a02679e076103bf0b320ffee012d28dccc17ff44"
    sha256 cellar: :any_skip_relocation, ventura:       "0009f5070467bd8e1b1dfb79050da99ee533061f77fb10621907ac0d22ca03bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf385395455232512ee22095cccaf8d729c3bf80560834bb6c193fc8a341ae1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"generate_test_docs"
    assert_path_exists testpath/"tests/fixtures/minimal.docx"

    output = shell_output("#{bin}/doxx #{testpath}/tests/fixtures/minimal.docx")
    assert_match <<~EOS, output
      Document: minimal
      Pages: 1
      Words: 26
    EOS
  end
end

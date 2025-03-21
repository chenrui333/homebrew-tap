class Tlint < Formula
  desc "Tighten linter for Laravel conventions"
  homepage "https://github.com/tighten/tlint"
  url "https://github.com/tighten/tlint/archive/refs/tags/v9.5.0.tar.gz"
  sha256 "3c9f82955e533ad18df6715441e1772b0614cf51f7168ddced54861575758076"
  license "MIT"
  head "https://github.com/tighten/tlint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977e11fd8d9b94e70467b715e9b0758657dbf0dec343d6426eee45419604571e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656054ca4d546f8824c5c275f4cc90708e6591522927aa19ab0fe752ec92ffac"
    sha256 cellar: :any_skip_relocation, ventura:       "791d898302a45c897aaaf8d34e4d04dbefd34ca34a833bc5b1b446635f51befe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4865fc52f823048237dba46a230f5b36a9719fc5379494d4e582870483a91cce"
  end

  depends_on "composer" => :build
  depends_on "php"

  def install
    system "composer", "install", "--no-dev", "--prefer-dist"
    libexec.install Dir["*"]
    (bin/"tlint").write <<~EOS
      #!/bin/bash
      exec php #{libexec}/bin/tlint "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlint --version")

    (testpath/"test.php").write <<~EOS
      <?php
      echo "Hello, TLint!";
    EOS

    output = shell_output("#{bin}/tlint lint test.php")
    assert_match "LGTM!", output
  end
end

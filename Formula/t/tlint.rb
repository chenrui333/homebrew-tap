class Tlint < Formula
  desc "Tighten linter for Laravel conventions"
  homepage "https://github.com/tighten/tlint"
  url "https://github.com/tighten/tlint/archive/refs/tags/v9.5.0.tar.gz"
  sha256 "3c9f82955e533ad18df6715441e1772b0614cf51f7168ddced54861575758076"
  license "MIT"
  head "https://github.com/tighten/tlint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "744b10768f3695f80beb17b42434f006ea332c67137e869d616059e64a46d3b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4efb19148dd048e3c7ceea8ae75cf784560205886bf8198bcc86655621c4585"
    sha256 cellar: :any_skip_relocation, ventura:       "022a8a785cad92ae79e93e8136763fd4f6655560e77b8f5c8770570e8b25bf09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ccd54460de93bb918ce03326ba509b7b4fe5e703be9b9c35929765b1de7b262"
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

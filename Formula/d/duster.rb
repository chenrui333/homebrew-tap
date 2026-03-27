class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "ce8a408bdc92389b84e0e010f612e834079444bdbe0562973c6a6f648100c18c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0c3f58ab1007c2ae43dad43bbc90a9257873100a2b0ba2b2a433d3a88d105680"
  end

  depends_on "php"

  def install
    bin.install "builds/duster" => "duster"
    bin.install "builds/duster.phar"
  end

  test do
    # version fix PR, https://github.com/tighten/duster/pull/188
    # assert_match version.to_s, shell_output("#{bin}/duster --version")
    system bin/"duster", "--version"

    (testpath/"index.php").write <<~PHP
      <?php
      echo "Hello, World!";
    PHP

    output = shell_output("#{bin}/duster lint", 1)
    assert_match "Linting using TLint", output
    assert_match "Linting using PHP_CodeSniffer", output
    assert_match "Linting using PHP CS Fixer", output
    assert_match "Linting using Pint", output
  end
end

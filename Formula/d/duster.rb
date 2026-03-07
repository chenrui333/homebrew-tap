class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "7e7909ef2b4b4bc491cf4e7c8dff19c20e71500356a5888d8ed5d8f11d63cf7d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "ffa7091fcecdbe003fa91689ed8de7a53535ca964b0daaef42dff9c7a834548e"
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

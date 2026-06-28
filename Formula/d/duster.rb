class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "6c2b6dd70e14d5049482d8d9421a383e43819e0aea2dd44a6505b9b507132cc1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "8d36d38e4223eab3fc2c529fe87ab779c6eb8952ac5e8e119e7eb438ab20e4ab"
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

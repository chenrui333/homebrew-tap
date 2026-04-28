class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c912d7e241dfcf144504b72f6bbb4a27e535693bdde6ecefcf84dc68acaf88e6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d87695509851daaba4f3230470112d06ae1c21717f1a6338ba1406fdd19311"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeeea84772638e16e905e3ab5719157fb07719ef48dbeb7889494a2a22368839"
    sha256 cellar: :any_skip_relocation, ventura:       "5d81caa653fe9f2cb516c534005b127b079702bc69b2813d73ec8d3b64d7e01b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985f82bf8f865c5feb1cd76313ddfd35df42b7346beffb7a40b7297024a0fec7"
  end

  depends_on "php"

  def install
    bin.install "builds/duster" => "duster"
    bin.install "builds/duster.phar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duster --version")

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

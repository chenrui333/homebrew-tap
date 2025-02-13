class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "ba1a0c3e52004d134615ee1134fbc0c6b33f57b23bf1befdbbfe7cd03ba76625"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d52e02ebe0d1e07d87091a1fb5d98a527e74c2d631a220ca32c3837013508d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527e18da6acb932142282bdd0225e8d241c42111ba4d7e9895a96cab6045ab85"
    sha256 cellar: :any_skip_relocation, ventura:       "edd4e0dca67386c9fdf652bb0744d4b8661375c25b7deb8735fd581242aba96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84b90e4dee542e4f8aa44969f5a3d68f468c40641cb228a9cf7e3d20bfc6e02e"
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

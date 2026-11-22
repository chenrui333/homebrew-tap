class Duster < Formula
  desc "Automatic configuration for Laravel apps"
  homepage "https://github.com/tighten/duster"
  url "https://github.com/tighten/duster/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "a9c2c7b99e833688a2e1f8fde5e150119c5aaf7a54fe43ebef8fc2f8ee1b4fd4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a59bda84601eb872ebe788f1e1e7a39b22bd80d4d18c65d43c5584d980a2faad"
    sha256 cellar: :any_skip_relocation, all: "3f79739993672285cf8d35a95a0a116520e9f87cfe3281e7ee80b73327a2f248"
  end

  depends_on "php"

  deny_network_access!

  def install
    bin.install "builds/duster"
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

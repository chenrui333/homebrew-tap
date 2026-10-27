class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.7.1/box.phar"
  sha256 "aedabb38bad96a90868603f118956c3faa662b545c06be66df1b145aba703c0a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "4d6dc226f8b16df0a69ced4fe47d4de5dcb1d03b23772e7ede12813f313464f1"
  end

  depends_on "php"

  deny_network_access!

  def install
    bin.install "box.phar" => "box"
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/box --version")
    system bin/"box", "--version"

    (testpath/"index.php").write <<~PHP
      <?php
      echo "Hello, World!";
    PHP

    (testpath/"box.json").write <<~JSON
      {
        "main": "index.php",
        "output": "test.phar"
      }
    JSON

    # override error_reporting to 8191, which suppresses deprecation warnings.
    system "php", "-d", "error_reporting=8191", bin/"box", "compile"
    assert_path_exists testpath/"test.phar"
    assert_match "Hello, World!", shell_output("php test.phar")
  end
end

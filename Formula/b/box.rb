class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.7.0/box.phar"
  sha256 "3d390eeaec33288098fe83f8a54c60cc575cb6be295f38ff4482b4b4f26f8d52"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "90106abc8ffb8aac60387b9c04057d6440ba70f1973e51f34236334a4ce92828"
  end

  depends_on "php"

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

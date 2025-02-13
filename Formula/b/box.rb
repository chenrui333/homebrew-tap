class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.2/box.phar"
  sha256 "3bfb1c1f37a74a78d1178bb92c508de4bf202aae0fb3f33f69ec3577c452de18"
  license "MIT"

  depends_on "php"

  def install
    bin.install "box.phar" => "box"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/box --version")

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

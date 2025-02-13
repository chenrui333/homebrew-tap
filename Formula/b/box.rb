class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.2/box.phar"
  sha256 "3bfb1c1f37a74a78d1178bb92c508de4bf202aae0fb3f33f69ec3577c452de18"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b963a77c1b9b3ae29f912236978eb49a8f63b8a15bfcef940a32a0544c41d505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e411cc620e4a0156b0bc238c5704a058c08770a4173e9af24f4caaca17a8198"
    sha256 cellar: :any_skip_relocation, ventura:       "271859179ecc35b95dc1981904056d0352244b3f90a3a06c4f505c7338bab923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7920a78c72a97b58f203b0a69852e00ee4b96333eda5aa1b68dc7fedc8b3580"
  end

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

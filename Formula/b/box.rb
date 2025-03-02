class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.6/box.phar"
  sha256 "aa0966319f709e74bf2bf1d58ddb987903ae4f6d0a9d335ec2261813c189f7fc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad825d2e8082624d848b81702d3eb8cee53a9b8ef32cdc91a6d1753a580b08f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "236c582157b8fbef65cae694f647b9da8fd4bd3d1412a6bc6fd20b836108d778"
    sha256 cellar: :any_skip_relocation, ventura:       "36107b451deacff66cdacdb11daf41472848d6f53323a9bf3fb656c0479361d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a590c0ef7b024db7176e66e071636472d5c1f729ee79367a62f989e54ae0029"
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

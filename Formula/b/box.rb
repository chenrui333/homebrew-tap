class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.7/box.phar"
  sha256 "f49a711985219c9e0ef9faa49a95d8ab47385b8b8966dc5ac0ca10f9ac318e6b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a19a732110154dabbe352e1a8041391291d9474580b98383cac3efb208ffab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f6a1e38068168bbd3040d0459245c36a5cac5ef23dd8f7c83954ee79fe5d8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "df298fa0705581a55a52e52b0de0d6184d4aca3fd4462e5dca89ff5fda0ffb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e849793c92415c8d08a5dede04c5c1a84227bafd27a4cd0cedbab99517af82c7"
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

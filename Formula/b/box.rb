class Box < Formula
  desc "Fast, zero config application bundler with PHARs"
  homepage "https://box-project.github.io/box/"
  url "https://github.com/box-project/box/releases/download/4.6.5/box.phar"
  sha256 "bb7c252839fde99bbad8a0573fb1fbe7aabe659e093917f16ef685def1161d19"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcbeaa3c682037d1e146f37148df7cacc46b4c576a11645eac99194750e7f537"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa79978a075915536105c6b4ef22e3c321b4f35ba12a7329493807d065bceba8"
    sha256 cellar: :any_skip_relocation, ventura:       "69e609be32829128a158d7ef894b1991b67dacd7a04d582cbacd32dbfac01c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c83ce02fc9cd58d4353ff13f2af35d88e6e789ce0713f021f1e3c180f80567"
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

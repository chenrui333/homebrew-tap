class Phpinsights < Formula
  desc "Instant PHP quality checks from your console"
  homepage "https://github.com/nunomaduro/phpinsights"
  url "https://github.com/nunomaduro/phpinsights/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "124c9c72e664c80399d89352a0296b7dbaa41f0e96bbde07cc2fc108374c5035"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "7d2081641a9488e5e508745b1336d2694d98de56c0efed5c4148065292fa0a3b"
  end

  depends_on "composer" => :build
  depends_on "php"

  def install
    # The upstream version constant can lag the release tag.
    inreplace "src/Domain/Kernel.php", /public const VERSION = '[^']+';/,
              "public const VERSION = 'v#{version}';"
    system "composer", "install", "--no-dev", "--prefer-dist"
    libexec.install Dir["*"]

    (bin/"phpinsights").write <<~EOS
      #!/bin/bash
      exec php "#{libexec}/bin/phpinsights" "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phpinsights --version")

    (testpath/"test.php").write <<~PHP
      <?php
      echo "Hello, World!";
    PHP

    output = shell_output("#{bin}/phpinsights analyse --summary #{testpath}/test.php")
    assert_match "[ARCHITECTURE] 100 pts within 1 files", output
  end
end

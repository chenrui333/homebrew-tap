class Phpinsights < Formula
  desc "Instant PHP quality checks from your console"
  homepage "https://github.com/nunomaduro/phpinsights"
  url "https://github.com/nunomaduro/phpinsights/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "bb19abf1c9edf100ed29c9b1c8442f46bab10b296cee2305d8d177b26bd28361"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "30281c9023dbc579c92b9ce10f3565ad5755bd0f6a142b438960f65a40b1bf23"
  end

  depends_on "composer" => :build
  depends_on "php"

  deny_network_access!

  def fetch
    system "composer", "install", "--no-dev", "--prefer-dist"
  end

  def install
    # The upstream version constant can lag the release tag.
    inreplace "src/Domain/Kernel.php", /public const VERSION = '[^']+';/,
              "public const VERSION = 'v#{version}';"
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

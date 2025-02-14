class Tlint < Formula
  desc "Tighten linter for Laravel conventions"
  homepage "https://github.com/tighten/tlint"
  url "https://github.com/tighten/tlint/archive/refs/tags/v9.4.0.tar.gz"
  sha256 "dedb30ae516f1e9fd3e4d04fb250679a28fcdfe2760cfcb24ba98a94418953f0"
  license "MIT"
  head "https://github.com/tighten/tlint.git", branch: "main"

  depends_on "composer" => :build
  depends_on "php"

  def install
    system "composer", "install", "--no-dev", "--prefer-dist"
    libexec.install Dir["*"]
    (bin/"tlint").write <<~EOS
      #!/bin/bash
      exec php #{libexec}/bin/tlint "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tlint --version")

    (testpath/"test.php").write <<~EOS
      <?php
      echo "Hello, TLint!";
    EOS

    output = shell_output("#{bin}/tlint lint test.php")
    assert_match "LGTM!", output
  end
end

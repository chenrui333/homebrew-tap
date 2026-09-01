class Tlint < Formula
  desc "Tighten linter for Laravel conventions"
  homepage "https://github.com/tighten/tlint"
  url "https://github.com/tighten/tlint/archive/refs/tags/v9.7.0.tar.gz"
  sha256 "92f5cf31a2c68575dce8640ec75542c56e5887417da1fcfaa540d23fe5128107"
  license "MIT"
  head "https://github.com/tighten/tlint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "d4a89e54090a153bd6bced09f58226d1a4877553703ebb23106d781f486e91a3"
  end

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

class Tlint < Formula
  desc "Tighten linter for Laravel conventions"
  homepage "https://github.com/tighten/tlint"
  url "https://github.com/tighten/tlint/archive/refs/tags/v9.7.0.tar.gz"
  sha256 "92f5cf31a2c68575dce8640ec75542c56e5887417da1fcfaa540d23fe5128107"
  license "MIT"
  head "https://github.com/tighten/tlint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c002f1c40f5d049d7c97090ef3abe974d450ea80730d4de4ce394bb0ba650d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e69169df5613671504dc53fadcb3a33cef3574bac983234e946b82b8c9e0351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e69169df5613671504dc53fadcb3a33cef3574bac983234e946b82b8c9e0351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f41d40f09dd3a7b05de6f2d5863ec7f3ba2638c2125c40bd28ceee3afc1b2410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41d40f09dd3a7b05de6f2d5863ec7f3ba2638c2125c40bd28ceee3afc1b2410"
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

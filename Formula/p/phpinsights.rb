class Phpinsights < Formula
  desc "Instant PHP quality checks from your console"
  homepage "https://github.com/nunomaduro/phpinsights"
  url "https://github.com/nunomaduro/phpinsights/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "27d5c2c84c6bb04b9c0dd0228073c40a79e206734a645a546dabcbc53a3fb8ab"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79ba611fbcd6ec5d603a25e9891bc7a874bf2f0bf472e6c03b38f1f1f3f05a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a8ec7895dc19bc213cb46aaa175bb50dac72cb68472689f8d737942e8667dd"
    sha256 cellar: :any_skip_relocation, ventura:       "5841e53580d97bc9a8ebfbedde4214a5237f98cfb7014a0c32b692fab5047536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08c45a3a35c34f509b663ed27daf7cbed2705b03bb929ba263f238d1394b52a0"
  end

  depends_on "composer" => :build
  depends_on "php"

  def install
    system "composer", "install", "--no-dev", "--prefer-dist"
    libexec.install Dir["*"]

    (bin/"phpinsights").write <<~EOS
      #!/bin/bash
      exec php "#{libexec}/bin/phpinsights" "$@"
    EOS
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/phpinsights --version")
    system bin/"phpinsights", "--version"

    (testpath/"test.php").write <<~PHP
      <?php
      echo "Hello, World!";
    PHP

    output = shell_output("#{bin}/phpinsights analyse --summary #{testpath}/test.php")
    assert_match "[ARCHITECTURE] 100 pts within 1 files", output
  end
end

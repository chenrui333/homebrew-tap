class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "1c5757f621405cc8ba80e9a60a98a37a659fdaf49523100ddc8c0ba6851150e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47088b76a56981cbf23ff6907079e97b4de2a7a42cf0b0f22864d2ef76327fef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2dc2594dfaeccd970e08857f3e5ebfedc60cfbdb23699bd4a82063a3f646b5"
    sha256 cellar: :any_skip_relocation, ventura:       "d38956c7097480ee3193e772ff2d959f8fe7b2643451a43fd8d94affa230684c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b416777c7f4c13fa578b5ccd1af5ea2a8cceb59d7fd70cf153012a9b95df95"
  end

  depends_on "composer" => :build
  depends_on "php"

  def install
    system "composer", "install", "--no-dev", "--prefer-dist", "--optimize-autoloader"
    libexec.install Dir["*"]

    # Create a wrapper script in bin that calls the installed castor binary
    (bin/"castor").write <<~EOS
      #!/bin/bash
      exec php "#{libexec}/bin/castor" "$@"
    EOS
    chmod 0755, bin/"castor"

    # remove non-native watcher
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    (libexec/"tools/watcher/bin").children.each do |file|
      rm(file) if file.basename.to_s != "watcher-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/castor --version")

    output = shell_output("#{bin}/castor list")
    assert_match "Available commands", output

    output = pipe_output("#{bin}/castor init", "no\n")
    assert_match "Could not find root \"castor.php\" file", output
  end
end

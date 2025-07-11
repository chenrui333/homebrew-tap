class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "e3cec28b06cc5842f68acd56bcc2ad239f657a04067cfe655b8f33ad7bb79ceb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec79a55e552d3166b3eb92ddc0e2383127b03e01af99eee597fa9f00ed9a8310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecb943e5dde8dc89b38535b05f0159e9f42476bb3d97edf64eacc3990989e7b"
    sha256 cellar: :any_skip_relocation, ventura:       "a2e81bbdeeb9395c89b10f82bc910822216bc90e343b789b6748681fd92fb51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5fd377a2eb305705b066120330878ec2114869b8dd346b288faedd7478a362f"
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

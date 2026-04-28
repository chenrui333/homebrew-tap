class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9dfab832eeb7b9256d9987ab546898d7550eb4413bd2683c0c2e70b6b719250a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df9f09dc04f66a04ade0f47a3cbf055c29270eba36129e401c0555cbfe61d4d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df9f09dc04f66a04ade0f47a3cbf055c29270eba36129e401c0555cbfe61d4d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9f09dc04f66a04ade0f47a3cbf055c29270eba36129e401c0555cbfe61d4d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc9fa92ad267a8b9c2b588a06a30e4f2acacc0554d5d1f5d7b7082e3a7bc8d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8589fb278b3b72f6737db3740bbb6cff5101a2fcbb1a10181bd7647af55877da"
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
    assert_match "\"castor.php\" file has been created in the current directory", output
  end
end

class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8c94b6a5a7da3284f79bf4ca71654573ae5a579ec691b4bcef3c1807f94bbb6d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d25305c62dbdeb90332cf0c255aaa0d09cf3e86a22e4bdecdbb5244ebe2edce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d25305c62dbdeb90332cf0c255aaa0d09cf3e86a22e4bdecdbb5244ebe2edce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d25305c62dbdeb90332cf0c255aaa0d09cf3e86a22e4bdecdbb5244ebe2edce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46aa5b4d4e584cfeb1a00e38481e96dbc51492a58a493d6c0506f77edc19fa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03744d5b2e1929282c397483b4b75c55bf1f3d262a1879cc656dbdf37a38b0ce"
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

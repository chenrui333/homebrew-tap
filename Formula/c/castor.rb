class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2f92303833acbd40430d2f67dececada48cab1f2534018493a08777204204d4a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "626e81b11e5cdc8d24c79b2b3fa3158a24bc182da3f4439c184d54d3dc04b2d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "626e81b11e5cdc8d24c79b2b3fa3158a24bc182da3f4439c184d54d3dc04b2d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "626e81b11e5cdc8d24c79b2b3fa3158a24bc182da3f4439c184d54d3dc04b2d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c612c30c9610accd8d21d449a8333ebfdac6e540d1bf704d88170ce053794e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a1de2fa9ddfde1759983b9be9d2fc3b6a7765b1b078f101c0fb03410780efc3"
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

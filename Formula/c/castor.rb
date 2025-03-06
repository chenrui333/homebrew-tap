class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "686455e5f33aa3af4d8f4fddd37e99b9cc2e5335ed1ff57279123b8dd98e176b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5670b9d3ed37f902bc0440c9394a469da06effc84b31c7bf60fef4a7effaad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "293ba586c88a96ed9e2fde7140c2e49875b9fed9013c1cb70204645e798eef6d"
    sha256 cellar: :any_skip_relocation, ventura:       "f50b3051293918cf7abb60925e2c084206052dd708c63468dd594330f7b67484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9f47589da15e971648a8b8cb5d398041f2d74c017a7714b15b491370bd175e"
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

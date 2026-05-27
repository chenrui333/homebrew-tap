class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "603c61a8963d17d523a3b9f70e8bef045c2009200d130d6385a6d6ceffa0ac05"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93d39e81b8c53d437dc63b11006e341230a4ab441720cea51e9dc30ade4699b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93d39e81b8c53d437dc63b11006e341230a4ab441720cea51e9dc30ade4699b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d39e81b8c53d437dc63b11006e341230a4ab441720cea51e9dc30ade4699b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b3cb504583bcfb1ca52eebde1c5824a44f3509ab9f85485121c1a364cc043b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ac418867649716fe375064037cf6ba7aaacbd82c54164d3aa1b638fb2ae9f1"
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

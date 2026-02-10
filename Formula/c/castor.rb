class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f9d4019983d27bcf0f9bf8061c16dd1363bf82ce9bbab555ff0bba2df0e17dd0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1c46aaa8e5bf01b5a5a669d59aee9593c18dd52e9aff07a974daa0aff9b42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1c46aaa8e5bf01b5a5a669d59aee9593c18dd52e9aff07a974daa0aff9b42d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1c46aaa8e5bf01b5a5a669d59aee9593c18dd52e9aff07a974daa0aff9b42d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1f1c7b3ea71dac06f9fe44dba20401bf0111de277422068c6218289d8c71dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891d609933ffa0f9d68e75532741542ded137d04f458427b4a14b7141ef36e16"
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

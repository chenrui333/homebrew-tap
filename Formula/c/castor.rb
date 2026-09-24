class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e5bd22385a989523ac11a6c33a1f01e1cb211a96e09e23a446e250114d547883"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374b76cff8130eba95f215b7e4bf3e000759e62a37b2ebe3b290c663e5ea0a63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838d803e45fdd4e288656a5b343b9595f93ceacd5fc530b1f9d11319faaf82fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c137615810981725315e8ec00d9e2ef6afe081f3208021636445e4f9333f7a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f966f48629f451fdfaa9383b89a98074c9554dc3c172ef453d2c361bd80bd710"
  end

  depends_on "composer" => :build
  depends_on "go" => :build
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

    # Build the native watcher from source instead of installing upstream prebuilt binaries.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    cd libexec/"tools/watcher" do
      rm_r "bin"
      system "go", "build", *std_go_args(output: "bin/watcher-#{os}-#{arch}", ldflags: "-s -w"), "main.go"
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

class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "8ffe9241e6d17df7d8ebf3138b3d10bcab39328bd083d82ad83d034c8788c49c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92303274fcd6dad5a92ec1e9ad06e0e6ae327d3140e345d1f668ee1d84e235ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58eeab5d4932f38a461cf5e447df63aaec0940b7cdc4c203f919a671dee25fe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93670cae75d9554967352ae1257ee8bc3f4e0abf4acd5a9f62e5476da029552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fded6d8273bd8043dd4beb9f53a53403d67f677be51b3eea22338503ee240e"
  end

  depends_on "composer" => :build
  depends_on "go" => :build
  depends_on "php"

  deny_network_access!

  def fetch
    system "composer", "install", "--no-dev", "--prefer-dist", "--optimize-autoloader"
    cd "tools/watcher" do
      system "go", "mod", "download"
    end
  end

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
    ENV["CASTOR_DISABLE_VERSION_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/castor --version")

    output = shell_output("#{bin}/castor list")
    assert_match "Available commands", output

    output = pipe_output("#{bin}/castor init", "no\n")
    assert_match "\"castor.php\" file has been created in the current directory", output
  end
end

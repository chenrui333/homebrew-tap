class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "8ffe9241e6d17df7d8ebf3138b3d10bcab39328bd083d82ad83d034c8788c49c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977a21c48be3c9eca1fcb4e862bb097574ab96d6f47e914e96ce63862d62adf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409adfa8c683e918a6a1b119c082ddba6219c9682c3fc7aac5c54900c84f9777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b9d973578495b77ac24fbebafcef1c972bfe571d219664264ac3cb536661782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f0845fd0084ac1308eac497689be6616cc566287fea6ba3cffde9333c11c5c"
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

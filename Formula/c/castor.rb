class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "e1bf8848cb01ba96d5229fd48ec6621167edf79a851c8c9ecf9e3ce82e234d0b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1886b533b154c6ff571b0b0e516d4eae63452c1d9f4c691d3a93d0119fa807f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19673633fd55e721abceaa5da1fd5b530f81844d3744a787f6df04575770648e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5123cbd9803ce1ef90700e17eaa34f48e2a54bf8899e27b02c99e931bf03de85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad92f3023ef231b903f782ea8ef5e97a6567c653306f1f73fea2731ef51ace9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c52690487ac1a36c9b6a2cef71f9fc390bbb683108a1efc3776d3d5fe6e9fb70"
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

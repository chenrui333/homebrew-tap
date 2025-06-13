class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "8f4ad66949ab4006bc33ee3d87d884e853e5a253223130949a43666b1f810a06"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "266afe688e9b9d931c50fa549c7ffb6f8065eb65b48d6125b51ebca1d78a14fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4254d342da97563e8651aa28752ebf004242ba652c14ec9f2fb34abdc64094c7"
    sha256 cellar: :any_skip_relocation, ventura:       "da00d1c6494c71ef884eb745a55aaad957301549cb0b5f9b622652ce4830f501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91d663473cec759acbcb4bbeb82bcfb4f67dd09c176b6dcd1847dfcd9d11221"
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

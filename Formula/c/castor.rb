class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "686455e5f33aa3af4d8f4fddd37e99b9cc2e5335ed1ff57279123b8dd98e176b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81524e8f0c78acfe9e51c57ac98f19f2447d11812ea567b0a3f078c06c77ac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea6b193acf0ce3fce0151b3bc8cf7514ff3e130800e9ec49182c6f673639d288"
    sha256 cellar: :any_skip_relocation, ventura:       "8c837d742dc1668c758b3ef573575413c807bdd866a55d787af9117d5d35c6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20690dce1476565ad064aeb3be3057acccea673ae783497e12a3aef23947a50b"
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

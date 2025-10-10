class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "23655faed04be0c957c9d1ecad011fc5e8a313cd41634c33a9faa4609caf50c5"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02586afb288dfcbc343ab0593bd5e481f7fce6aa119b79fc6651cf603d92ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a02586afb288dfcbc343ab0593bd5e481f7fce6aa119b79fc6651cf603d92ccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a02586afb288dfcbc343ab0593bd5e481f7fce6aa119b79fc6651cf603d92ccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "075334b81ebea92fa493c56a8ba1716bc021f02a2ab6fd4f58b0fc66de3dc09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619970b66f3bed93e9f06149a0924d76e8c6d0c635c80980e279fc9b9500a1e3"
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
    assert_match "Do you want to initialize current directory with castor? (yes/no)", output
  end
end

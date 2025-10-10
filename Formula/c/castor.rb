class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e22b21f02d9305b3a0753c75c54abefe6d4cd8c099127f0ed5f92366f3705594"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9476643bef91126b93b55d4bf41f65ce7410444f0eeb7b59221fd2dad1a2106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61fd1a722e9527cfa07e4b6d3d48177b93df1ba213242e3833d150ba7313a2d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b1da08d300e0925ced0baedb8144c45d74637b38e0256063fbe2485e21eb36"
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

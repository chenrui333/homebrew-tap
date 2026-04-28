class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "1c5757f621405cc8ba80e9a60a98a37a659fdaf49523100ddc8c0ba6851150e8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869f7dca424e6ed0bdcd5523cec0f0f57b8dc8b6fe77017078d3b22e81450e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd408c4f4be558b0c640a479a056dd6a4a931f96caa58f5174104f81ac78969"
    sha256 cellar: :any_skip_relocation, ventura:       "3a60c116de7d7c002fea10ab6ffe8bec887c49682861487fe37beffd6d661c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ac9345ba9e84fed2f34ebb29ae1239e76dd4550193aa99d8f1689ce1f600b7"
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
    assert_match "Do you want to create a new project? (yes/no) [no]:\n", output
  end
end

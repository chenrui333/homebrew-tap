class Castor < Formula
  desc "DX-oriented task runner and command launcher built in PHP"
  homepage "https://castor.jolicode.com/"
  url "https://github.com/jolicode/castor/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f9d4019983d27bcf0f9bf8061c16dd1363bf82ce9bbab555ff0bba2df0e17dd0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d406da32c82f279f738773588241b50ee555ec8d9e75133de3d3db7917b72f05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d406da32c82f279f738773588241b50ee555ec8d9e75133de3d3db7917b72f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d406da32c82f279f738773588241b50ee555ec8d9e75133de3d3db7917b72f05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec4eaf855af3449c801680f6ef141cb821db9f0c1dab268fc6926d36369692c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f381419d003fd939f97602361a767db1c3848c59c52bc177ca5e75216223caba"
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

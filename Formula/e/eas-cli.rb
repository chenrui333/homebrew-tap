class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.11.0.tgz"
  sha256 "2549813f6aee3b65d352d763ac7623e4c8480de492b38d8b5e068e6e6e1733f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98453d02293bf65f9a201c6abd2015eece06fe00927468202b673e652eebaaf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98453d02293bf65f9a201c6abd2015eece06fe00927468202b673e652eebaaf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70e3569c92039133e3f0ddcc06c33f316ffb5111255f7ba985af415cbe4e6ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e3569c92039133e3f0ddcc06c33f316ffb5111255f7ba985af415cbe4e6ac2"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end

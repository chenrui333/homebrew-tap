class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.20.0.tgz"
  sha256 "a07537677e926dacc9b4f1adba8139088544c600eeda36c66c7346fd0b3d537b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16f0817aae77ad5f41e891bcbfea012762efd6ab8ca4ebe918eb2873a6277ff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4915c733fdcaf09b8b97dee76b4ef21d7a53e0aa9c46caa79d43394d714e5e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ac9ae3de5538cecfad15b241914a62172c981e7f8c1a3a85d383e79bb2b5ca8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")

    assert_match "Not logged in", shell_output("#{bin}/eas whoami 2>&1", 1)
    output = shell_output("#{bin}/eas config 2>&1", 1)
    assert_match "Run this command inside a project directory", output
  end
end

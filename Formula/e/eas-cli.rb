class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.19.3.tgz"
  sha256 "4862c1a738ba56c7597e6cf2afe944ab3f82a254be3c420ae545cbdb17c55e3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7449b41cf6c35b6df90eb9015665ab28a635c5538a4c1e0dafacf87449a59e71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa07655b785c9037b433d7a85dc356db6756b1a848307e1a83b1b82a73c8ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80d241c49ff40ce97b4112b82668560da9371ed3deeba04e6d55c41caacd756a"
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

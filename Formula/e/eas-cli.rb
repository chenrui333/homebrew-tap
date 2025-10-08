class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.20.4.tgz"
  sha256 "283e33c3b5de1d86222b654d6db96236a6a6e11900c096fcbd92e5ac58c9413c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09aa22686a95a41081aa08845a9ef5b19f06b300479957300e18400a892ac55c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f1ae7d25b26ae734933f85af70454e1d474f3659c440dd39c912d805307d6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d703b9b4a43dd2d9c34412e4a7a6c06a5eaadeec0e5621f404ba9df8d0289ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3604e45718459ad5c69dba934b5b72e808c63f4d8c903b3da19db16a1760ae68"
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

class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.17.3.tgz"
  sha256 "224e31db7f95bd417228ce5dae4b77b89b0240de743ec5d611232393d078ccb2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30490759f6915dd3e468ea3b711c82e61d83ae02187cb71a8820f333f16ce8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b9acdd3f017b4148cf98a149106addfc8b1bdad57b9ce413480df1c0b77c47"
    sha256 cellar: :any_skip_relocation, ventura:       "4c8a3f5ea09810f96e5772d260edca435f2e198b01ae1ad065c20ae222385ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2c63f3d609d393118917c663d6da67e3c8ac2a48f110a8d508bef7a341a4ec9"
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

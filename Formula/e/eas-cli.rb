class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.20.1.tgz"
  sha256 "4858ffc5627adff3d4196f63eae27c4fb71c128d39ca7b642677bcacdf69849a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb342ac696c924f362b31f0f302f0ec6938e6729a911399bf43a8df9d236a1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09700642d2674dd62f9a455bd8104d2901e5e0f367d959e07fcd708e4fdb2b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c96e2c4e96e80afa3969e7cd31066a54bc7f612fabd14d4e74ec11072ebac24b"
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

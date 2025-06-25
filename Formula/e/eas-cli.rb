class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.13.1.tgz"
  sha256 "15367bb29a8f502469a55d24d27303a310a1def015095413b789a94df8a348a1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9674028649ee9407f08a47addc0f03f9f46cfeac47227550c6762eca89aeb229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c7e3d6cb2dd39f7a031e1a21d462cb69da58b8421af804b684fae66b98fb4c6"
    sha256 cellar: :any_skip_relocation, ventura:       "762c23e6c077f2a79ce7a3b5ae0f4abd7590f9ef0b2d830ad24a8801d6e7d0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b79533994fe7213ed8c87916d35d32003ee5ea1766cf4edcea02edeac39d9af1"
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

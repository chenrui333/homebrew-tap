class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.19.3.tgz"
  sha256 "4862c1a738ba56c7597e6cf2afe944ab3f82a254be3c420ae545cbdb17c55e3d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b05bcf2ebbec110594b2fc1548bc4780ce7bdc0aec2a356ddbb63f531b7c0d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "add76de98654476caf1186cdb3abe9195c60e9daa6350ffa54feae180d95e0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a290f478101031aa6ec089072739cbc71201e944eb7b59eaf922e09b3320372e"
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

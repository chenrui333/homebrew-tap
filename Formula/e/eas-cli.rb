class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.30.0.tgz"
  sha256 "deeb15708db1a1dc7e523702d79866754035e1ce0877efb2012f8c2ddacca56e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f93f07a2c5e64ff4b814d8dd2448d3fc8dd14ba700195da125ffb6615afbbdef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedf2fbf91d4b782398942a5ab0b04a8e2bd041752bf7a9177bcccb73d7622a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b790ea0f49c770e4db5cb3e31916ce26232e88518f91d3224b9e4d8ec13e6cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb3851346f076738a95462f9a48065e464e27afc7772a6220e37863cc5b6a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6974e22b57f75adecdddbbdfdaa3a4b1a582dd9383b0adbcc5f8dd39a03e9f1"
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

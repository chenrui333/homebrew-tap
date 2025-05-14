class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.6.0.tgz"
  sha256 "15beb80772156a5716a4c582e19e6ed5183b8cb600d0f75d76f1f6c49e697d4e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b9de299bf817bcbfee4580e117af069f143fa519d838eecebbd837002b3f360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "970c29d5a0f42aded31e1cf9875dcd770bd8728187c28ac98079fdff22c0fbf9"
    sha256 cellar: :any_skip_relocation, ventura:       "a2f3a5d4219ee30f872c04ee6b6135fe4eb523fc6f2a50c063fcb139cc4f17d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5aa20ce132bf13f8965ada74a2bb06652e0b13fd6e680373c32d8a8fa929e30"
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

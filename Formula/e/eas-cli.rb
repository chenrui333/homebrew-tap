class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.13.2.tgz"
  sha256 "1bbf22a300b69a5e33ea067a38253f0dc802935fb9fdb9571c479c6cdfbeb907"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a12cd5fe64e5ac119d7f770ce942efb3ad7e588e1b6d7dec1e3d1b7d4eb69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563599579f11414786ec2f7664763e49d2b5d949925df8f1292efaec12ea8096"
    sha256 cellar: :any_skip_relocation, ventura:       "49a8223d0c68e56bf65358749e9838a1d1ac6a7546be9a0edc11f0dad3469a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de2dfe85a0767e019da16f24a94246bda29d8fd3eae483825fae5c68d97f3b4"
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

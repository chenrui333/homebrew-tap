class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.7.2.tgz"
  sha256 "2f8ec39299d8e29279597bad77bec03077c7a10b48a1b9c9c33449010086db23"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e66da0bf323c1f13835245c50716e07944b583bd313b5cbfc4c61891f07f187e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e76dc1e8fc6a6ced90ce62cfd99c0a44566d5c6584c8bf1a6326736f43728597"
    sha256 cellar: :any_skip_relocation, ventura:       "ec75eb9d32c0e9bad9106a26641f2be8277fd9035d7016c362307a14254b08f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea825e0e1d1500a8b80a2adabc4480c3522d17cf2e56267939fccf8a1eee5824"
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

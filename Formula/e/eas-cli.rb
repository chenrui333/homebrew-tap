class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.16.0.tgz"
  sha256 "a3f0bf92a1fb6d595dd1606a4f518ab385c5da19388f12edece5c2a500b903f8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12b48b2a431480e6c48f83116731e15e313dca33eb056c5a838b41cc476a879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8202362f22e53ebe83c04fa34f3f6c97906e9b8617717ee4d5f4af7924c4cde5"
    sha256 cellar: :any_skip_relocation, ventura:       "d1812c6956e1908eb7ef89539fc09ce91c273583758e55a50f2442eef7701c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb7c8b47bd2ec3f2bbbfbeeaeffee62af2df225d9f2c37175b2db1a06e607450"
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

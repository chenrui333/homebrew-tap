class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.3.2.tgz"
  sha256 "cf5ef7d147d497a6fefcde1dbd02200bbfabfca3a357074746f18cf7e0ebcdd9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7067bc2aec76a4517e4f492eebb2ddb993cd1cdcb9908349d65860e28d2bda6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1f31ed60675a10dba0be39f8843103e3edf4895a1e9e514cd0be6e581b62541"
    sha256 cellar: :any_skip_relocation, ventura:       "f62e3d09982d01e5c633062ffd4d1f7e566cefb1092a0377b7a9a6e06e7e90b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c50244a3a68a4d85c3a3f6e5e3c9365df7c3a3908334b8bc3ca14d6eded10f0"
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

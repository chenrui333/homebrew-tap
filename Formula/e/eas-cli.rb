class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.14.0.tgz"
  sha256 "48ce5a0da9e6fce3d5ee45cfc7ff449b0ca55fe4b1539325094cde686fb6f9c4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc1f738327359aa0f34e7338428915e2feeceaadf634e627d931e4f24571a03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4556cdd5563311d0e095f2483a22bca1be138fb1b1113cbf0080cb6484c828c"
    sha256 cellar: :any_skip_relocation, ventura:       "d8c7f916c2d7b5b6b931e2a7ff743bc5d78992f2c5f33c12f22953f4eaed8ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46fcafcd74e193fc533d3c4b07aa46b74d4db4add553961dad99f0424a767e39"
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

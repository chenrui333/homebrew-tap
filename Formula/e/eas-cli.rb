class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.1.0.tgz"
  sha256 "50f35e39903d5e39f76eb068aa085d3ba68b70cba96eb58b65c8cc1368d503a8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d536ca7c4061dfc08032fabe2b58e2438ddd90222545c910b05d533839d7d58d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccba86341238ae792f184c54ba268bed7c54065c89c9eb83cddee25709b905a6"
    sha256 cellar: :any_skip_relocation, ventura:       "d8c70544428133ec1fce9092bcd1f36bce25a02a8679d5f3d3f60fbf0d264b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186b7a35cc39cc79d303eb04666b19b54fdf079002d26f455c59fd8a511f1515"
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

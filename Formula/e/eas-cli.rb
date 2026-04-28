class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.18.0.tgz"
  sha256 "5353648ba2fa8c76534f0608a0754d30f0b5b7178cb0cff23c5dc8b8d9c93312"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6ad34015f252281b161ca599f948d6b0039c8730189d73cdb098ee2fdc6eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25dda57a3f129101c9b9e291836b81af0b2f4ced4062498cf2fe9b70a878c2b2"
    sha256 cellar: :any_skip_relocation, ventura:       "fa9400a2cadde9308511b1b6b9a9d5128cf1c70da8c5182b595728cfa5bef9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2bec6d536598f094999f81358b2ed60a529e9c132b1a1b2b9543b952b0fdfd"
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

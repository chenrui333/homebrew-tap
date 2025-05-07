class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.4.1.tgz"
  sha256 "08b633d9ba5e37642d701cd4782afaca057b56536b388f03c1a391cd22a9164e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68743f9b90fb52d982340520ed4a558cdc6489c7fbe7a276fa8834838cfb020b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89d5f1e0c5aebc39c3ea766936a3565cac3f8735dafbc1f8be644267ad92f76c"
    sha256 cellar: :any_skip_relocation, ventura:       "0d7620ef24af5caa528ba2c14bbf590d9cf87e57b0e16a9da11f353adee2ae56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70cff8a30ac8f3b168b5457c89a50d5140688d98291ba66f2641ecb52f53cf0"
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

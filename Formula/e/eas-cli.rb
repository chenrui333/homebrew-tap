class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.3.3.tgz"
  sha256 "27a660ab09806bba5d74329bc79e36df640d7b1f61d71ca95fba68c9be9bf883"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f35985b68c1573ccfa564966390b59b9e8ee5f643dd234be94e4404ca81feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c246d732a3bb57c13c52fc3687b24d6d7bb1176b35d6a01923f2d3782d31fa3"
    sha256 cellar: :any_skip_relocation, ventura:       "719c68038a367f2f20be8ad2faf54fde4b7b722dcb0c83ec42d66f246b3f85fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e215ef42c5e7e0217ac944390f91cad9c4ea65daf9c76919447d6df407a081"
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

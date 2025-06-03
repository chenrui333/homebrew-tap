class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.7.2.tgz"
  sha256 "2f8ec39299d8e29279597bad77bec03077c7a10b48a1b9c9c33449010086db23"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ce4bc9cd4ec9312fe775f139c341ee4eaf74e115d2efbd0c725b9699fea1f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e7e26325401fcd59d0a3afbaa1b46a4d5d258e738a9843c9f1ce681dd539613"
    sha256 cellar: :any_skip_relocation, ventura:       "2b8c8d50bf8b588aa9e00abde1fb6fd99b6bb94d48cc7e5f67f7ec28e806c6ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224f853e003e88d6f1be4f87a88dded62d66199562b103f1355f6e0695f38f07"
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

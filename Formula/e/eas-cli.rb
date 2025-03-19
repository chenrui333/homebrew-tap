class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.0.0.tgz"
  sha256 "c59a4bfab818d2fc3aaa04238d6659fe7afc2ba8b360a9b65f6c99f3c04bd48d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4c9a66d443c607726f8a529e2539647b10460532339fb900d863b2ac6f5b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b4b9e1f0f3f3aa786f69205c4f0605abf5688e37a7e1de043a8267e7ef1a88c"
    sha256 cellar: :any_skip_relocation, ventura:       "06dfbdd22b548b5430aa183a1910bee1222b16f679400e7b44b294fa872011a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35b33de56ae17562b4addaff9d74990fb5bd3f95fef887b9c2ff6a6217189a99"
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

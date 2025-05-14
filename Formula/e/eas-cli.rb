class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.6.1.tgz"
  sha256 "a398eb9738a5722eadfdabb1f7ce0f87e747e1c1db118e42d188a4566b6f7b47"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfca48f4c8ca9d15192c3916de47ae8d20d9d553c2bf3456c9bcc67e29ff8bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d2b201295c1feef3205ace5fb2638ae814bc0adfc9138d934cef658ffa6a17"
    sha256 cellar: :any_skip_relocation, ventura:       "716794b635154e7bb8a5c62af4b1b3a43929039d60445feb2a9cc90ebad66984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c93b9669e12177993331b0067a6689ece1d2a5273e70f92a7acd07b820837d"
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

class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.24.1.tgz"
  sha256 "fa3dc474ac61d7ac9e7c65169d2fd9e5604e5efa9f80ea5c248a9d80b82ab0d7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ec8d7a07f7c37a307df42d6c34104df8307f6c45873a7053276993db9fb0cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d0230f0ca9e7a1e4375417483b4ddb3e753936d964a432fec116f76c659aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2add221e462936a4e92756dd6d61928bc6296c40b1b610a6c42a139d8ad13fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1976885d9e1e1adfe8ab6e6e0f196555c9fe182ad9d3be349a3001315a29e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab88aac334b0df2886ebe1cfd2f7a2c3b5f9ff0a4bf7f9a660d5808533fcfb2f"
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

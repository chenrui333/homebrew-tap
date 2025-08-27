class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.18.0.tgz"
  sha256 "5353648ba2fa8c76534f0608a0754d30f0b5b7178cb0cff23c5dc8b8d9c93312"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5d453a0b40ed324fbca91951dc8517f74d0018d5fe19aba35cfbb8c0173141d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d4b087663214c21e9ae05cb2b00e9505521cecc511ab1ea7436dd557dda347"
    sha256 cellar: :any_skip_relocation, ventura:       "d37fcacfa01fd7017166a37cfbd91278a7e19b5f698afa2e81552fe5c40ae957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a3144b487fb3c7d9e6d9befa1c6c39d6f204f9b13b5ea6cab0a636b50cb2a5"
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

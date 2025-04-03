class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.2.0.tgz"
  sha256 "8b35b471f1631b73876444ea542bac9395fe4e90aad9052c86b7f4a1c9a25968"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "723a353a4e0fcee02ab5a1f8421beceeaac34f3bba2f9cb713097000bae69bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d5aef5da206bafb78d17c6001b9da2756e8077892b978056e5f878ba6e0edcb"
    sha256 cellar: :any_skip_relocation, ventura:       "d0ce45d908766407edde05240be3c2a07794e9857daf3921082226601746ac08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce0032451fe96d7ba35706973c896ac9bdabcd4f995d7fe2c9d07dcef7724d9a"
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

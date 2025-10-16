class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.23.1.tgz"
  sha256 "82d1527dbe1d730e92575b4d474018053849e9c360bcdc0fa1ebb33838814739"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9986d624f04b099ad3c0f3f83ce445b7245b76a87d7329eba99553b7c60b72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b88de86ba8633874f1c6fccf21a20f2bd9a3e74c73a263e0e19285107ef66718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad016692772606149740361f16b580030b0598aba8f58682b11b9487d9d7c4a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b41241b4270ee1222fc230f9686756986d82379d03f326730eb03c236ad049c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da2b912adad3127c6e03f5a69e015a5107ee8d67587961fd8a18b75566e67f7"
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

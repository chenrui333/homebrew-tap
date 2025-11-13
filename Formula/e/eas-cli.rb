class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.27.0.tgz"
  sha256 "546fe49e8b21437933150a7f6bd2071c0d9563758c04ff06b79c3200e3f0a86e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ae2329429ee25eb589627aa53275965251fb0b63139399510a71f67070ac825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b58a75907f457b6465d03337c38dc3c4c1c7ea0aaec5cdfd96d5f03a836c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e020408b03c7abc3c4c3bf20d5b2bec265fa35d47598b96f8aaae9013a4f777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6e74d77e24efd9a45433e4e60da99a9792056c70b33b6252589a45b39364e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daffb720f0d4d56dc311a1e4ae84514ad647120c8dbd695d08a92905a149e4d8"
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

class EasCli < Formula
  desc "Fastest way to build, submit, and update iOS and Android apps"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-16.21.0.tgz"
  sha256 "aa8e4b75f49de86d39ca3c929b90a4ea9a553b52362efba6f904ebaeff07ebfa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81bf3b39257596f96d4bb06c0a747a672a29babcb2c67001d5ac50eedb28a9b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a6d411adf8d66bdf901f630a503814992811dc939a2d7eebcc082385b817b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "019d0322795d7ce751270bcffee8654b6438ba79926c9e0552aae830c57ac6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e75cf8c3d367fab9fe0a48d148906132e27de3bbb33ba1b9f52d16efef18af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4875603a4160065c9fca9a4b60cc18557651edce2e028b65feb72a48b22d5a83"
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

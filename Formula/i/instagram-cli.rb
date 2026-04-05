class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v1.5.0.tar.gz"
  sha256 "8f75793417d138393e3f8c1f9f936f4aa99bee487ea1fb215585c2105641cd9d"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a9be0b06d8a5679829fdf6cc7a2907fa92b59573ad46ac5c0ce300192c1a5d99"
    sha256 cellar: :any,                 arm64_sequoia: "7b7ab4cbeb2ee868848936d72da523356a3607007812c9fd4c500f1315f61c7b"
    sha256 cellar: :any,                 arm64_sonoma:  "7b7ab4cbeb2ee868848936d72da523356a3607007812c9fd4c500f1315f61c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955301faad92b5c7e5b84efdd36fdb508960560516437df8d1d3cb372f8637c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771f5ed99fff3b5d1d187a8457cce1446f00e6f8afeefe8a84351961fb9694d7"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    # Remove upstream prebuilt reporter binary so audit doesn't flag non-native artifacts.
    reporter = libexec/"lib/node_modules/@i7m/instagram-cli/node_modules/instagram-private-api"
    reporter /= "node_modules/ts-custom-error/codeclimate-reporter"
    reporter.delete if reporter.exist?

    bin.install_symlink libexec/"bin/instagram-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/instagram-cli --version")
    assert_match "Current Configuration", shell_output("#{bin}/instagram-cli config 2>&1")
  end
end

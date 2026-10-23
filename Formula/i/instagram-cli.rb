class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v2.1.0.tar.gz"
  sha256 "018d78532416f596aebd70fb3a95381560f28edab882192a10cfd124a8b49292"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5fc85e40a435798e84c4239f8bce554081c05767b097508fe0b99464462e7dfd"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch", ignore_scripts: false)
  end

  def install
    system "npm", "run", "build"
    system "npm", "install", "--offline", *std_npm_args(ignore_scripts: false)

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

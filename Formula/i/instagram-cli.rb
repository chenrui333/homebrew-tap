class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v2.0.0.tar.gz"
  sha256 "72e3e93c1e3e31e3d47a0e9371c0a1f375c93ebe6f22f9a7e48761dd29d42834"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "acf35d6c1df08bf7b2fda6fd7eb6ada0ea95daf0112b938033a34945a034a093"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--no-audit", "--no-fund"
    system "npm", "run", "build"
    system "npm", "install", *std_npm_args(ignore_scripts: false)

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

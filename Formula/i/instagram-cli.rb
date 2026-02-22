class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v1.4.3.tar.gz"
  sha256 "e4c80adce130e0c3b0b2d0a561ff6142f32eac482558bafe9f25317887200736"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1e66f76efe293276c4367aee7b4b1cb3405f5d22cb28cadb07ee828cb77611b5"
    sha256 cellar: :any,                 arm64_sequoia: "61e13afe2e3d4b7fa8dc69886c5cb687e1f47a5e0a7dc787c59e4702d88603d0"
    sha256 cellar: :any,                 arm64_sonoma:  "61e13afe2e3d4b7fa8dc69886c5cb687e1f47a5e0a7dc787c59e4702d88603d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3ea723d7a875a1603fb6ab9d6ba17af8088caa6ac7adb736917d558a02f71ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad8b6eec7e7ec4232355fef9efe4701ed96c0cb2b083fef5909cec824d9644a"
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

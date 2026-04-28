class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v1.4.5.tar.gz"
  sha256 "428fe56c18b0fa4157622595bc348ee373e4dc2348c397116fdb792c86ea2ae1"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "eabe31efd49d1e755e6f494119691086bbfd8df3a2ea0c8be3365718fb5b9b61"
    sha256 cellar: :any,                 arm64_sequoia: "e9d2a5feb074142fa2e6ee6650f51bd14509e5a71647102d22accdef0dc8896e"
    sha256 cellar: :any,                 arm64_sonoma:  "e9d2a5feb074142fa2e6ee6650f51bd14509e5a71647102d22accdef0dc8896e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47be8ddc1a52995a00a7de7599f90480ff6bee62548872abc9176f56b7f55a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a377fa0408cad1f18341d98dca2745925dc7cbe03e7636cdac3d260ffe914277"
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

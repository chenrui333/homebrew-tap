class InstagramCli < Formula
  desc "Unofficial CLI and terminal client for Instagram"
  homepage "https://github.com/supreme-gg-gg/instagram-cli"
  url "https://github.com/supreme-gg-gg/instagram-cli/archive/refs/tags/ts-v1.5.0.tar.gz"
  sha256 "8f75793417d138393e3f8c1f9f936f4aa99bee487ea1fb215585c2105641cd9d"
  license "MIT"
  head "https://github.com/supreme-gg-gg/instagram-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3af820a5da28348aebee916796aeed6f1fd62d801c22ef9d6687503d53d65722"
    sha256 cellar: :any,                 arm64_sequoia: "34b96c402bd848d4f734326fb89330ae1d937e8c2c5beae5664e685da69b9353"
    sha256 cellar: :any,                 arm64_sonoma:  "34b96c402bd848d4f734326fb89330ae1d937e8c2c5beae5664e685da69b9353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d4baebeaca1dbbef791dbf9b91321afcfbee2ba300be87e41911caa0f259977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b812ea5c5d4a73cf6257704569fe942e68100dfef27656c8feea22fb354140c1"
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

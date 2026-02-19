class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://docucod.com/"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-0.46.0.tgz"
  sha256 "c3c9b583d95d371eafc7d47f413346f48ea4365cf894bdc99a3955e5b63c3fe7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "68b560dcc1ad29a38e3bafa57c8b689e521a0bbdaa8e415e93de59c23d389003"
    sha256 cellar: :any,                 arm64_sequoia: "9fa70fee4c2d0640df91670dfaa273bc04c03c8224c84ecbf3e1f76cfeaa0ded"
    sha256 cellar: :any,                 arm64_sonoma:  "9fa70fee4c2d0640df91670dfaa273bc04c03c8224c84ecbf3e1f76cfeaa0ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c86f4a8acfe0ea1fc81c41f925f897f60f34b6bc9144d3f0f12deb408f6d700e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323b267dabcdb1085a48304630974f29965c41db3091aabc87754cbc22cb042f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      (libexec/"lib/node_modules/@clidey/dory/node_modules")
        .glob("sass-embedded-linux-musl-*")
        .each(&:rmtree)
    end
  end

  test do
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end

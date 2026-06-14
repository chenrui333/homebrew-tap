class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.90.tgz"
  sha256 "7b1d588f96fec4b1708c84fa9b29debf12220dc72b75bee163f295e1c504cf56"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256               arm64_tahoe:   "2b4ac391c8774b6ec2b6c5517561a641c747f7850b3e8a1ad5ec8b9cd58b946a"
    sha256               arm64_sequoia: "cfaaad50fe4e6ccb8c16cc6524a9f1ffaf214107f60b32123a57670228ad9fe0"
    sha256               arm64_sonoma:  "cfaaad50fe4e6ccb8c16cc6524a9f1ffaf214107f60b32123a57670228ad9fe0"
    sha256 cellar: :any, arm64_linux:   "6c5db49a6b0728993a8fd5c4cbe84afdb38451b5628065aaec9b696c2e1a2bce"
    sha256 cellar: :any, x86_64_linux:  "940cb5285faa940ddb129cb214c02622e3e192bed3e0e74a65cc1a5185317f91"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # Keep only the native node-pty prebuild to avoid shipping non-native binaries.
    node_pty_prebuilds = libexec/"lib/node_modules/@getpaseo/cli/node_modules/node-pty/prebuilds"
    native_prebuild = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    node_pty_prebuilds.children.each do |prebuild|
      rm_r prebuild if prebuild.basename.to_s != native_prebuild
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

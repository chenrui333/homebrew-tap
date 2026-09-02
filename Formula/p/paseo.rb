class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.7.1.tgz"
  sha256 "e967a6f357d9dd73617243b9e8391229c1a45d2794593345b2f03b483ffee2a5"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "6cf805bb28bdb36ae7407e8bfd2da00239e6749ac3d092a23bba48e6311d26a8"
    sha256               arm64_sequoia: "6cf805bb28bdb36ae7407e8bfd2da00239e6749ac3d092a23bba48e6311d26a8"
    sha256               arm64_sonoma:  "6cf805bb28bdb36ae7407e8bfd2da00239e6749ac3d092a23bba48e6311d26a8"
    sha256 cellar: :any, arm64_linux:   "d00e38f88bcef174f85c821a365b23473f921ca6b41e4809b8731e94faf75cc4"
    sha256 cellar: :any, x86_64_linux:  "cae3d7a5cc1d58cc93c16fb9140d6a3596ba8b9382c77dd9b73c902043a2748e"
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

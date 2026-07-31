class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.2.5.tgz"
  sha256 "a5afabde237262b705b2921da7c23bab89a2f431ceda2472ee9cc19ca07ba54d"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "f15f1d64e81a4e4431c5d0bda5f4f0d0c6da94804fc04949274a7f5616c765c9"
    sha256               arm64_sequoia: "f15f1d64e81a4e4431c5d0bda5f4f0d0c6da94804fc04949274a7f5616c765c9"
    sha256               arm64_sonoma:  "f15f1d64e81a4e4431c5d0bda5f4f0d0c6da94804fc04949274a7f5616c765c9"
    sha256 cellar: :any, arm64_linux:   "e0c5bf8260f257b47a7738aece794b931b2995d30eec265a92fed285bc8270ba"
    sha256 cellar: :any, x86_64_linux:  "300d7814c9c536373ace5f467d463c8083f6245b9aa7c595132977aa72c16e2b"
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

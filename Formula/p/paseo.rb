class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.97.tgz"
  sha256 "db572d5164bd2aab01b18db353b4869d4f660b7c01baf3f9e320c5acb938014c"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "8d191687e14313804d858a9f194a6b244f10f63e8c8c6b9a5a605ec37119af76"
    sha256               arm64_sequoia: "0ddc2ca7b94ba1c20f8a0f1ea9828584149b7474cf7ae9f5f3669706dcf53313"
    sha256               arm64_sonoma:  "0ddc2ca7b94ba1c20f8a0f1ea9828584149b7474cf7ae9f5f3669706dcf53313"
    sha256 cellar: :any, arm64_linux:   "e206323aa13bbefc29ac9d9ede1e7e2c53d8fa68a4337c7b0bc71fd363f17e08"
    sha256 cellar: :any, x86_64_linux:  "c055ace3e4b70581a6bf8721b29e6cc74b09c0d47030bcd2bdc30bf400591ae8"
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

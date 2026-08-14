class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.4.0.tgz"
  sha256 "1cdba71bc5d245f6ad486c8f3e1c745fb75020c6d7f907883d78714a820ea190"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "890e78253f0885bdb5a0a9c85291c517bc543f07de4ed67292648030ae773a58"
    sha256               arm64_sequoia: "890e78253f0885bdb5a0a9c85291c517bc543f07de4ed67292648030ae773a58"
    sha256               arm64_sonoma:  "890e78253f0885bdb5a0a9c85291c517bc543f07de4ed67292648030ae773a58"
    sha256 cellar: :any, arm64_linux:   "96443b9929d86987ee829466f15ff7df146a86c1e62660d62d72311d17534d2d"
    sha256 cellar: :any, x86_64_linux:  "b297db14a0ae7618e9f0f214a39aabeb5a804b2c83c5e0b01c4d971c933af197"
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

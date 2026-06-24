class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.99.tgz"
  sha256 "ed8d04192d5f301d604629bcd472a4a4356ff824c648f1003de676132b509b41"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cb2d898e436bf2c476db9e9561c28d29c1982f5780103bd0bfdb297db622dcd6"
    sha256               arm64_sequoia: "e7edfddf3d7afc5db7215e75121526e54ccd9ca7b46b958b168ef1e3462ba214"
    sha256               arm64_sonoma:  "e7edfddf3d7afc5db7215e75121526e54ccd9ca7b46b958b168ef1e3462ba214"
    sha256 cellar: :any, arm64_linux:   "84859faa209a74eaa34d5761e2255af6dca34dd1860396d55599c04e028f6c40"
    sha256 cellar: :any, x86_64_linux:  "a2657d9cfc7722a66e8a42fec19f76947899c94f7cac908978465600a11c6e1d"
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

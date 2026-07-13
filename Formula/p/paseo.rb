class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.107.tgz"
  sha256 "53297afdd8e32087e6abe81f05467813b459779f4780531267000604eb772882"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "01c5c92a00f2b7406162146936d8d2dc8b4995c05038feeb227d948195366e0e"
    sha256               arm64_sequoia: "0d0fa703739db2884495308b57be9b23350f74a5d5470e2080dc034fbbfdd9e4"
    sha256               arm64_sonoma:  "0d0fa703739db2884495308b57be9b23350f74a5d5470e2080dc034fbbfdd9e4"
    sha256 cellar: :any, arm64_linux:   "8d200e49f38526141d2d05bff569e2bee217fc172df565bb47e9ede7fc9b43cd"
    sha256 cellar: :any, x86_64_linux:  "b578b66375c434890e962a056aef675b5b60b92d3976bff3614d524f756baa66"
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

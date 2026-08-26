class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.6.1.tgz"
  sha256 "0561419f340daf3e6d496bd5e6755532f671158634597f699a859d08a2066daa"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "6a05c56acc2b27e8c38b2691909d106781ac6cb482fd45a35251ef171238eb32"
    sha256               arm64_sequoia: "6a05c56acc2b27e8c38b2691909d106781ac6cb482fd45a35251ef171238eb32"
    sha256               arm64_sonoma:  "6a05c56acc2b27e8c38b2691909d106781ac6cb482fd45a35251ef171238eb32"
    sha256 cellar: :any, arm64_linux:   "a8f7854395387544eefb26427c3b6f74e769e26846d50518a0844365f39a51f9"
    sha256 cellar: :any, x86_64_linux:  "9d9916a1d0980b5253ff4d0c43c079a268cdcdd09b96a36c634c42eb6ee3de6e"
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

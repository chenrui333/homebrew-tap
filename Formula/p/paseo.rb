class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.101.tgz"
  sha256 "38ef371ff05c642124b433c7d34d58f751ea71b900a6070a504ad3ede859dcd7"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "8940235b24e984c1658b164f5340acd2d24b3863a2826c4de1ea14b48da20f07"
    sha256               arm64_sequoia: "654a55caa9d1518359b6c27bd31e4abdeb1b6c0b625ff6f864ce33afd63c1486"
    sha256               arm64_sonoma:  "654a55caa9d1518359b6c27bd31e4abdeb1b6c0b625ff6f864ce33afd63c1486"
    sha256 cellar: :any, arm64_linux:   "fa114a9be72d329d3f0343ea977b166961886615aa7fab209c33dc0134d1f1b6"
    sha256 cellar: :any, x86_64_linux:  "6eb3fe74b3974536d242c07059c756ec093ebeb3e2c07e81d7bc7d5977ff114b"
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

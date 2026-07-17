class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.1.109.tgz"
  sha256 "d75bd700601b0efde8b336a379cebf9598517a5ad8b41543f547e53270b5bfab"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "fbaee276a6836d1b199fd20872f1669a8cc293bd3524a054cb48b24f29f2dc1a"
    sha256               arm64_sequoia: "d9848da93b0ce5d2d42126857face992682803bf944d97d000c46bd1838eacba"
    sha256               arm64_sonoma:  "d9848da93b0ce5d2d42126857face992682803bf944d97d000c46bd1838eacba"
    sha256 cellar: :any, arm64_linux:   "08ce958a9877fc90bb5f854dfa6b7805234d6cf4f8de46b526efb527c7f56da5"
    sha256 cellar: :any, x86_64_linux:  "f4de7db0396c2369363d4e47fb692da1e265768b8798a5bc1f76d5bccb43e0a7"
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

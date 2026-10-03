class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.10.3.tgz"
  sha256 "ad39b7d87db5b5e99e23d3fb09ef4f17089e36e0900045820c8b55dda11b20a8"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "0f4b2b5f5638d222a98ef1ebab7c8b25d3c92029da15b64a7d888c4df6509735"
    sha256               arm64_sequoia: "0f4b2b5f5638d222a98ef1ebab7c8b25d3c92029da15b64a7d888c4df6509735"
    sha256 cellar: :any, arm64_linux:   "7764998016dc070922187c248fd7d49e1b76ff49ff7e78f0c68c20aae29ac610"
    sha256 cellar: :any, x86_64_linux:  "ed9baf83a0d595ed06fdccddfc01009931afc9a914ebb45fb736bcaec778840c"
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

    # Homebrew Linux uses glibc; the optional musl binaries reference libc.so.
    if OS.linux?
      libexec.glob("lib/node_modules/@getpaseo/cli/node_modules/@msgpackr-extract/*/*.musl.node").each do |file|
        rm file
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paseo --version")
    output = shell_output("#{bin}/paseo --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end

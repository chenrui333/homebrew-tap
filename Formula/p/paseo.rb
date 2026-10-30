class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.14.0.tgz"
  sha256 "4fd2334404a3aeea0f270b2c51938eecf74e782a5d898a7248d210773f4c0593"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "dfda902a22f3f0decc11b1cf7911deff59c8294eb5c7531ca1ac668319813260"
    sha256               arm64_sequoia: "dfda902a22f3f0decc11b1cf7911deff59c8294eb5c7531ca1ac668319813260"
    sha256 cellar: :any, arm64_linux:   "4a0e688a3af83081bce86eb01a0fd7ee708bb2c3b2d25aac828f5eb23b576a11"
    sha256 cellar: :any, x86_64_linux:  "ae9ed50de676c8101023129da18ffcb5bd8d24298e6aa9f1824f7a7d5bfa7c23"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

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

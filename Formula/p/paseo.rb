class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.11.1.tgz"
  sha256 "d5b4fdec84e02ed6ea6fdaf0d095488f546a49f3426e41d7c29a4b82a99923fe"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "c20cacb782fce138c745d978e938fdb973a7bc1ee5fb180a83bee348af5171f0"
    sha256               arm64_sequoia: "c20cacb782fce138c745d978e938fdb973a7bc1ee5fb180a83bee348af5171f0"
    sha256 cellar: :any, arm64_linux:   "437d678e817a6bc1486b07caf0a7e6496f7494013e3e3f5b914f04ac6b5b2919"
    sha256 cellar: :any, x86_64_linux:  "cc8d28c5836939b653fb515fc9987bb423e8a8a0abee6a2ad4c8e00c1e5d1f16"
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

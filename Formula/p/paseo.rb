class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.16.0.tgz"
  sha256 "981aa1ff2b5d36ce36302d31a38e9b61b4a132622328ccf077993748ddd5210a"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "38d5f591f80480923e313bd9727a696e84dcb54d7cc22f4c90bec277904a55e7"
    sha256               arm64_sequoia: "38d5f591f80480923e313bd9727a696e84dcb54d7cc22f4c90bec277904a55e7"
    sha256 cellar: :any, arm64_linux:   "343bfbf9c6bae903864c805f3c5a94ed89bb0eb6eb25ab5ff4db2fd5761fbf43"
    sha256 cellar: :any, x86_64_linux:  "e3a482344cef5c1d795dc28d32a8031aaa1feeb4cc6abb7d36f5e57686967cbc"
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

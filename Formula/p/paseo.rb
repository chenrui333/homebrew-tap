class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.15.4.tgz"
  sha256 "fd31167cede41c6a789b0d634dc9e9176d5f1ccc872cd7c698829c49eb0715d1"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "b1c0f98ff5765c9477b9e0c263b43e5ebbf0011fe33ce68fa389a2a9244db809"
    sha256               arm64_sequoia: "b1c0f98ff5765c9477b9e0c263b43e5ebbf0011fe33ce68fa389a2a9244db809"
    sha256 cellar: :any, arm64_linux:   "45cd28e5b4aae8df1f3e00acba4ff4704993f295440d6f06ffe23adc90053667"
    sha256 cellar: :any, x86_64_linux:  "ef1261bbc162d92a9c3bc36ae1348eeaf0e86fa3b72c2112eb3ac0d3c38c11e9"
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

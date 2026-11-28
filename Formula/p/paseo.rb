class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.18.0.tgz"
  sha256 "5217716fbb29104b7ae7ff8dc3c0bf5c574623a3b45f521db2db2f0f0f458fac"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "660c66d4c0c65fc64a21648c5db4ccc441e3afcf0bb1e93fb1024b3d984998f5"
    sha256               arm64_tahoe:   "2695f7b623728122f63198199654e2643c36a0f34efa8c7105a12cc1707a4cd4"
    sha256               arm64_sequoia: "289816bd039d9ba96428a35356fac69035221959f0462e151abb3cb15a9000f5"
    sha256 cellar: :any, arm64_linux:   "8d540193d8d1f328a4069eec2dc9c47f989fcf6952b492fce2d4e12848afa2e6"
    sha256 cellar: :any, x86_64_linux:  "25dd092281a1d847d9791ca7d669592aa3124f7f50f6d692f2d351b201f0c3ed"
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
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    native_prebuild = "#{os}-#{arch}"
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

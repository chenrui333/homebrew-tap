class Paseo < Formula
  desc "Control your AI coding agents from the command-line"
  homepage "https://github.com/getpaseo/paseo"
  url "https://registry.npmjs.org/@getpaseo/cli/-/cli-0.18.0.tgz"
  sha256 "5217716fbb29104b7ae7ff8dc3c0bf5c574623a3b45f521db2db2f0f0f458fac"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e123e1e0c05ea1c16984986f4bfff661fcc98fdbf822d13b40a4c2c35ef956d7"
    sha256               arm64_tahoe:   "7b87ec0974b9889a5be0c49916c9aa6f15447cb34c94a3b2d83d71c8227ef6ba"
    sha256               arm64_sequoia: "7b87ec0974b9889a5be0c49916c9aa6f15447cb34c94a3b2d83d71c8227ef6ba"
    sha256 cellar: :any, arm64_linux:   "a552785d128bf5cd53dadfb2a108956259c9117cf956f542f1e256ab48c7c74b"
    sha256 cellar: :any, x86_64_linux:  "622f22c7f6774d2dc5b47aa03caccb4b8d373e6434fa41e05df1a88884134680"
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

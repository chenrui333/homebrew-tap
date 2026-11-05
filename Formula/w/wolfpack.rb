class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.28.tgz"
  sha256 "6c83745f9e4733f3c28e9806a20b39b6a1ab9f5f5bb6d6d4b23afb0ba8715c2b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0911d6f2d43ee06967e7ce71e3b0f4bbc40dd8ac3527d000c4c5f5e3702a8113"
    sha256                               arm64_sequoia: "0911d6f2d43ee06967e7ce71e3b0f4bbc40dd8ac3527d000c4c5f5e3702a8113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad0ea0657b8206f78448900e0f33f9e3e647c3e2883a9bbc13339059c7aaa757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b52cb3bff18d0e7b8dc63c4eb7ecc598041589389c28f96c2aa075cf45f30d"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wolfpack --version")

    output = shell_output("#{bin}/wolfpack not-a-real-command 2>&1", 1)
    assert_match "Unknown command: not-a-real-command", output
  end
end

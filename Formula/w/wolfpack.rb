class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.24.tgz"
  sha256 "b6dac7210acd2a96c9406ebea680da11e8353f2a97b8817fb07d1bb146fc55ec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256                               arm64_tahoe:   "6835bad1b460b4d1163ba0ee990903adaffcdad791da48a8b84abfdcd1f6cdfe"
    sha256                               arm64_sequoia: "6835bad1b460b4d1163ba0ee990903adaffcdad791da48a8b84abfdcd1f6cdfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d34a833418f6f4f703910cf1bcd0c2f70d3c5fad30c7b8a64b9ff7472abd2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02925d864bd009bb4a5d2f938d43b6faac8ccfd794ab55e89c1cc1c2b1afffb2"
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

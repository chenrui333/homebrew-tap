class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.24.tgz"
  sha256 "b6dac7210acd2a96c9406ebea680da11e8353f2a97b8817fb07d1bb146fc55ec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "2e5f47b1ac162e56279815f93a51622c0e59d0bc6d4488aa14451e35df59479b"
    sha256                               arm64_sequoia: "2e5f47b1ac162e56279815f93a51622c0e59d0bc6d4488aa14451e35df59479b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200fccd9173415115083062fd663861e542b7b9d40fb92b43a6cfb27864b0785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "115aabf7f442fc7012d2c0985ade1500e2dcf41673c43e7c6ed34add77171c3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/wolfpack-bridge/package.json"
    output = shell_output("node -e \"console.log(require('#{pkg}').version)\"")
    assert_match version.to_s, output
  end
end

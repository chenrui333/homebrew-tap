class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.24.tgz"
  sha256 "b6dac7210acd2a96c9406ebea680da11e8353f2a97b8817fb07d1bb146fc55ec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0c5ad4b5cbbf4b21c645ffaf5848beaaea0909979aa92011130d9db6f2dced24"
    sha256                               arm64_sequoia: "0c5ad4b5cbbf4b21c645ffaf5848beaaea0909979aa92011130d9db6f2dced24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec870231148519c2f58c549324a85fe1a69a0c6d5deaf24a877c6b1ff20a07c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc04dad8a58f901a4a58b359b08c1e57b194f305bb9db1c065e3b0bd051d5c04"
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

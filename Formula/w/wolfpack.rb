class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.26.tgz"
  sha256 "e003f66b1145a2f8e356e72fa35c3c8ad203e4d31ee4cbb2c597028139871e09"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "a35096e2ff47eb2b2702b5ab70e12a0434e093aa86c54869e1ed2fc45c890eb9"
    sha256                               arm64_sequoia: "a35096e2ff47eb2b2702b5ab70e12a0434e093aa86c54869e1ed2fc45c890eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58731c5868b6d8d9cdf0b6bfb370984fb57be97190fa26034d37bd5cae3f751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8eff07e14118a9a77258a88176c535ba99fe52119e3cdc9cbab37287021d4b8"
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

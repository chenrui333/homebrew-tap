class Wolfpack < Formula
  desc "Mobile and desktop command center for controlling AI coding agents"
  homepage "https://github.com/almogdepaz/wolfpack"
  url "https://registry.npmjs.org/wolfpack-bridge/-/wolfpack-bridge-1.6.27.tgz"
  sha256 "75d3c6f8a1138d1db6f7030519cce0b727e4eb916b28ed1dc8750cfabddf8aa2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "10dca37066ec6c903269fd3b274c52a43b5d579860cc140194c9f265a4f510ee"
    sha256                               arm64_sequoia: "10dca37066ec6c903269fd3b274c52a43b5d579860cc140194c9f265a4f510ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1411e1b883e51c0664365b56c92a0b1d942c97ad3d254347ef11c4f8a10882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a4f12e7be6264f1aeee12eb0903378ba19efd45379a318b2e110bc01a19303"
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

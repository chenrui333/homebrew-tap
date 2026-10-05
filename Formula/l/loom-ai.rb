class LoomAi < Formula
  desc "Loop engineering for agentic software delivery"
  homepage "https://github.com/valkor-ai/loom"
  url "https://github.com/valkor-ai/loom/archive/50c758a6cea097afb94570498540f3200a295120.tar.gz"
  version "0.1.0"
  sha256 "37644525db2dd648ba8b695a8634b7ad7e1f08b1eb26e76f92327c2932c6a772"
  license "Apache-2.0"
  head "https://github.com/valkor-ai/loom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8cab14a03dcff7fee32672e4666dcbeef366e41608813a8c62bd61c342eef864"
    sha256 cellar: :any,                 arm64_sequoia: "8cab14a03dcff7fee32672e4666dcbeef366e41608813a8c62bd61c342eef864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab0187dee69930b4a9398ce2e9c551df80aa5f820871e6e3231f1b32f80584e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "407cebca69a2cb0bc87fe35f207642df90dc0e7a6c6cd4b41e19b55cfb552033"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "ci"
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "run", "build"
    system "npm", "pack"
    system "npm", "install", "--offline", *std_npm_args, "loom-#{version}.tgz"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/loom --version")
    assert_match "loom", shell_output("#{bin}/loom --help")
  end
end

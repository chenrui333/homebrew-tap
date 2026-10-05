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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "e3ad1c575e367a52977c615e2e9952e921aeadce4602d1d6abab6f5bd74cbcc6"
    sha256 cellar: :any,                 arm64_sequoia: "e3ad1c575e367a52977c615e2e9952e921aeadce4602d1d6abab6f5bd74cbcc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75d69fb628244c6ab1c6a04e546233fa047a37263d1fe6ad182675d63ae85df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f97191c9c3f5083a46c2ebd6869c5eee802c959dfbd2c78b70ce4cd1b3980c9"
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
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args, "loom-#{version}.tgz"
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/loom --version")
    assert_match "loom", shell_output("#{bin}/loom --help")
  end
end

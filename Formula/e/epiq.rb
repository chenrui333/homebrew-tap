class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.17.1.tgz"
  sha256 "276eaaf33ea44a245c9cc59cbd0ae30dfcf7615ab5d19762ad25697e601c59b3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea8c1c60be5708a65386d67532a0f2e3c687a1c09f67eb407f122758ec3cb768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea8c1c60be5708a65386d67532a0f2e3c687a1c09f67eb407f122758ec3cb768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "447b0171868a379ab3b4f207d0f2eab512435d34f10e38d33b3cf235ba994d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "447b0171868a379ab3b4f207d0f2eab512435d34f10e38d33b3cf235ba994d1d"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/epiq --version")

    assert_match "Unknown command: not-a-real-command", shell_output("#{bin}/epiq not-a-real-command 2>&1", 1)
  end
end

class Testronaut < Formula
  desc "Autonomous testing with OpenAI functions and browser automation"
  homepage "https://testronaut.app/"
  url "https://registry.npmjs.org/testronaut/-/testronaut-2.1.13.tgz"
  sha256 "f788b7f5a50baaa1213db3189a7bfd71d221514dbee2c1e3638646252aab35aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "8fff3f2ee81a70eb22bcef6fe2eab02eb8249b317f27964e2283617d073b213b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6521a6f5f0f88eab386fbb5bc1649337fa5c2b7b5e933bafe2493facb00cd221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6521a6f5f0f88eab386fbb5bc1649337fa5c2b7b5e933bafe2493facb00cd221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "645cd70d85108bfee5ca854bbc04135d4ae590b42ce229924c5e6f2ad590351a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645cd70d85108bfee5ca854bbc04135d4ae590b42ce229924c5e6f2ad590351a"
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
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/testronaut 2>&1", 1)
    assert_match "Missions directory not found: missions", output

    output = shell_output("#{bin}/testronaut serve 2>&1", 1)
    assert_match "No HTML reports found in missions/mission_reports", output
  end
end

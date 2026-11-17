class Newsjack < Formula
  desc "Open-source skills that turn your agent into a full PR team"
  homepage "https://github.com/elvisun/newsjack"
  url "https://registry.npmjs.org/newsjack/-/newsjack-0.1.24.tgz"
  sha256 "062f693ea05f28a89f4fe1b54925fed44157ff8e4f30aa926cdfe1297eb8c755"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7978e129846bba3cd6ca2c02780eb1e4d288aff2120102a7d1bef81a99eb7db4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7978e129846bba3cd6ca2c02780eb1e4d288aff2120102a7d1bef81a99eb7db4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e171aabfcf2cf1e5c2c0fd07460c76d9f0453c89188d20d1ce4400dd08e4721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82dc4ba20c6f44b35f9888fb33ed029b8aeda1ed957124c6e7109f460a3829ae"
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
    assert_match version.to_s, shell_output("#{bin}/newsjack --version")

    output = shell_output("NEWSJACK_AUTO_UPDATE=0 #{bin}/newsjack doctor --json")
    assert_match '"root_ok": true', output
  end
end

class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.19.0.tgz"
  sha256 "b362baed48609ef143989ef511440630109fec8223891b179fcd007ca4c1a4b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de9c2893ec2fb2aaab05c8d9a4d877d7894717fc9539c1befa00494c1830524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23f7d93ec4c56758481e5ee3d978284a803e704fcb9c0032cbcc7aeb9699f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9de9c2893ec2fb2aaab05c8d9a4d877d7894717fc9539c1befa00494c1830524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de9c2893ec2fb2aaab05c8d9a4d877d7894717fc9539c1befa00494c1830524"
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

class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.12.2.tgz"
  sha256 "2693a08a653c871e690da2efdc686568112d65bee9253c1e8fb7d58531e4d736"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "e3f6f55c23bf47e012f047e1c2936cc45aaff1e39c6d0b37ef07ac4b5af2409a"
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

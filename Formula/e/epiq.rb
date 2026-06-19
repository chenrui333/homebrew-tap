class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-0.7.4.tgz"
  sha256 "68162c9e3cc87ca88dbd89ec631e4fa4951f2df3fdb2aa4b7cbb6bf2846bd403"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1f551336758f4189c1162c31e0f835084a9b228b52c382966e10b45825945f21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/epiq --version")
    assert_match "CLI based issue tracker", shell_output("#{bin}/epiq --help")
  end
end

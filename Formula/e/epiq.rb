class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-0.7.8.tgz"
  sha256 "df18715c0c8b84917e2c548d31ce3f6459e95e6a38853ba972d811c588d925f0"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "58456ef9cce5ec83239376a84cd56bb702bb564e70d90d82fd658dd365209e7e"
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

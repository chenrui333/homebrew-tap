class Epiq < Formula
  desc "Distributed terminal-native issue tracker backed by Git"
  homepage "https://github.com/ljtn/epiq"
  url "https://registry.npmjs.org/epiq/-/epiq-1.19.0.tgz"
  sha256 "b362baed48609ef143989ef511440630109fec8223891b179fcd007ca4c1a4b7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "96a9bfafa576b9dac7dc1370e1b34eef3f64f24b5ff4330f99dbc68e5c445505"
    sha256 cellar: :any_skip_relocation, all: "346c3a40f5b7ebeff707834d1fe8d9c847f29bf65a504aa8424528e44f6fd1d4"
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

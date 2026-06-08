class Mnemo < Formula
  desc "Local-first AI memory layer with knowledge graph and semantic retrieval"
  homepage "https://github.com/zaydmulani09/mnemo"
  url "https://github.com/zaydmulani09/mnemo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "840dabaf752b5b5ebd385bb353d6eb521581d7ac7963c9bfc43601a89e4b2248"
  license "MIT"
  head "https://github.com/zaydmulani09/mnemo.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mnemo-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mnemo-cli --version")
    assert_match "mnemo", shell_output("#{bin}/mnemo-cli --help")
  end
end

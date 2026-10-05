class Mnemo < Formula
  desc "Local-first AI memory layer with knowledge graph and semantic retrieval"
  homepage "https://github.com/zaydmulani09/mnemo"
  url "https://github.com/zaydmulani09/mnemo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "840dabaf752b5b5ebd385bb353d6eb521581d7ac7963c9bfc43601a89e4b2248"
  license "MIT"
  head "https://github.com/zaydmulani09/mnemo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33e22811057be617e6272052c019d577779f151ac8d13bf5a71755f725c9138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7d4918c3ac07fe474da064050fc23d2c1328dcc73546fe1b0225fa8edde83f"
    sha256 cellar: :any,                 arm64_linux:   "1966ac9b5ffae26332c5740ab8991ef5cf2ce12adef880e8dc4956be60558cd5"
    sha256 cellar: :any,                 x86_64_linux:  "8f7d6679a4b1ccbc6318499b781b8d6c48ec19b5791776c71102e0483a4e5128"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mnemo-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mnemo-cli --version")
    output = shell_output("#{bin}/mnemo-cli --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end

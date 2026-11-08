class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.72.tar.gz"
  sha256 "5ce616b8d6c409055afb6ee31574d580840e2f8a4af80b922326ab1171b7115b"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee04f795d213bcc4e04a47de4cf4480c36bbe6c2341dfe62b9223066b5a0372"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b31988e3b515556958e5ae069e417bb6f4b7e9e1fbb65986d083911bae8d217"
    sha256 cellar: :any,                 arm64_linux:   "322e2cbad58b0f07c83ec5bca8fb1a91ad48ad8904cbf7cc45ef040225f2e5fb"
    sha256 cellar: :any,                 x86_64_linux:  "f735be2d6d9e9335224b3dc613cc45ab78d88bfc8993b99395121e2e1a0fd948"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end

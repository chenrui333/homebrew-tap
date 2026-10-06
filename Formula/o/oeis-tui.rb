class OeisTui < Formula
  desc "TUI and CLI for exploring the On-Line Encyclopedia of Integer Sequences (OEIS)"
  homepage "https://github.com/hako/oeis-tui"
  url "https://github.com/hako/oeis-tui/archive/refs/tags/1.0.0.tar.gz"
  sha256 "68bd20b731e17ef54708f7c26cdc901488e0948056bd5d519e16fd720f3c0d58"
  license "MIT"
  head "https://github.com/hako/oeis-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6d8936ac0c6919f6d50739352931130dfed377cc915430407921024f1be44b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988f0d8ebb955262ba997a82dfc198c1680390d8bd45468c9262597be39593d8"
    sha256 cellar: :any,                 arm64_linux:   "cb5d351106f4d2ea88f4edee98974b4730548576967b1f284539fbcf1d4e6797"
    sha256 cellar: :any,                 x86_64_linux:  "0a709dc853b30ddeed46ca46471359c3da4e4eed07db6a1b843fbb720d998596"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oeis --version")

    output = shell_output("#{bin}/oeis fetch foo 2>&1", 1)
    assert_match "Invalid A-number format", output
  end
end

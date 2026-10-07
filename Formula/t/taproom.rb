class Taproom < Formula
  desc "TUI for Homebrew"
  homepage "https://github.com/hzqtc/taproom"
  url "https://github.com/hzqtc/taproom/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "85ee7660bb76ed9277573d2c856bcfebd3181b919edf3862e7f9e15d32097088"
  license "MIT"
  head "https://github.com/hzqtc/taproom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c6cbf766372f9971e8fc288a273cddcd096069f25d00c98b4be755e2a8e931b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c6cbf766372f9971e8fc288a273cddcd096069f25d00c98b4be755e2a8e931b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d205e4ef1d926bb8643fbc9f213f0f254c7461996df7957be6682ea20479982c"
    sha256 cellar: :any,                 x86_64_linux:  "1c9681d79fbf1a8d8c265163909ae39f30aa62a112fba87160547c4faaf83990"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # v0.6.2 predates the upstream version-file fix: https://github.com/hzqtc/taproom/commit/a26afac788a5122356bf9c07c3c3d04fabae76d3
    inreplace ".version", "v0.6.1", "v#{version}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taproom --version")

    assert_match "--invalidate-cache", shell_output("#{bin}/taproom --help 2>&1")

    # Theme validation exits before the TUI starts loading data from formulae.brew.sh.
    output = shell_output("#{bin}/taproom --theme bogus 2>&1", 1)
    assert_match "Invalid theme: bogus (expected auto, light, dark)", output
  end
end

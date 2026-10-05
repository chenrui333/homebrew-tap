class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  # Upstream re-pointed the v2.2.4 tag to a Cargo.lock-only fix, so pin the tag commit.
  url "https://github.com/aguacero7/rkik.git",
      tag:      "v2.2.4",
      revision: "dc84b5266cb1c288796e4bb2dd18d6659e8e90b8"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f691a8aa4f472d807a814f7ac0319e7a8bfe8c440ff541b84fc304fc82343d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d145d0fb061c289e86266b86a3b418821f7d1e977d8d8407dfc052e97fa8d0"
    sha256 cellar: :any,                 arm64_linux:   "b843aaf04ff05b32737b8429d391015c9aa4d79c0c2e4cbad7bdfef1bcf93812"
    sha256 cellar: :any,                 x86_64_linux:  "21973221404728d66f0569fd1099958016779faf11c845775edf2600659ef77f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # TODO: Remove when the next release prunes the unused `pkg-config` entry from Cargo.lock.
    inreplace "Cargo.lock", /^\[\[package\]\]\nname = "pkg-config"\n.*?\n\n/m, ""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rkik --version")

    ENV["RKIK_CONFIG_DIR"] = testpath
    system bin/"rkik", "preset", "add", "test", "--", "ntp", "pool.ntp.org"
    assert_match "test: ntp pool.ntp.org", shell_output("#{bin}/rkik preset list")
  end
end

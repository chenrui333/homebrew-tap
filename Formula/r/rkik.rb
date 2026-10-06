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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39af80826c2ecc7b50a5ad9fd636ca2edbc251718ad747ece0f4760f1fcc65aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38b8820ba25ac5f811ff318504033f1764392a4e39ce00c5e788f1781781e6cd"
    sha256 cellar: :any,                 arm64_linux:   "600c47203689d76bfadb9cc053aa713ab220445763bf14b7dadd27463851a937"
    sha256 cellar: :any,                 x86_64_linux:  "bf9c7646890fadf7f06270d20adf2a4aa1b65bcf12e153a73fb6d36c38b6c61e"
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

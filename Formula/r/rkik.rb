class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "3f5e0724d1719415b93ff9f30323034d3156fc2e573e7cb348781f086f7614d6"
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

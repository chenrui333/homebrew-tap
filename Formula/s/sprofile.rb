class Sprofile < Formula
  desc "Blazingly fast TUI application for viewing your Spotify listening activity"
  homepage "https://github.com/GoodBoyNeon/sprofile"
  url "https://github.com/GoodBoyNeon/sprofile/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "453464c1b1a7d25bf4e75ea7222e5cf2aab766469adb0afab8d8f5d999ea50c6"
  license "MIT"
  head "https://github.com/GoodBoyNeon/sprofile.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27c5e379d8fda0dc532baa95606a34b04d6d9c3982e86da79e7d3f90f5313726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d38bae7949404ac0c3860f35d78595aea660fb21e6cdcae7e644be2807391a"
    sha256 cellar: :any,                 arm64_linux:   "8cd0cf2d2cd54b78fdc21849cb76532695ec3651516f776538c46aaaa2488824"
    sha256 cellar: :any,                 x86_64_linux:  "4f00335720baf4f9ee97821e3f4860659b3100cde72e5118af96cd882a177610"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    # Fix the stale sprofile version in the v0.2.0 lockfile (Cargo.toml is 0.2.0).
    # TODO: Remove in the next release.
    inreplace "Cargo.lock", "name = \"sprofile\"\nversion = \"0.1.1\"", "name = \"sprofile\"\nversion = \"0.2.0\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"

    pid = spawn bin/"sprofile", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "* * Welcome to Sprofile! * *", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

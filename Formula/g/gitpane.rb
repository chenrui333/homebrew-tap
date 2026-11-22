class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "f1c5174b8afe3226eaaa9f52a9845778ffac8484be71c8fb7a929f2955de9c68"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "551c856096519489ea8be714bc8601f2e178b3ceb342344452fff5a6b7db2a69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d6a97847f7a98e6934df714495af2bb806b029865029da65fd35054ee63a1c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c6eb761caf0626c2ab45b263f153f674c65bcedc571ada19224bc0bc3902f1"
    sha256 cellar: :any,                 arm64_linux:   "08646e1a806ea59c361b5d3a6806d7a5828dda1e03b88374be25bacaecd0ebbd"
    sha256 cellar: :any,                 x86_64_linux:  "76e1cf6f4c2a8b5f09ba685c0d9ff1b1362e0f9d8c12824cb03040930f7c8617"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gitpane", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

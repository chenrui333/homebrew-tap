class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.27.tar.gz"
  sha256 "bfc619bac91faa6efeb7d09ac9e2eac2f073b58a107c25c7018c6e19fb5f52e3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8c1f15f21645569410606ac7d9f8019aea18a7b9e12dfb407c38be9d09997c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e88a151dd326fabc567aa7e7d06ee1cc0d9b70478b2f8bf73bd5ae8e76cc3ed"
    sha256 cellar: :any,                 arm64_linux:   "f037faf850d60917a6e57ea85338eb41bdcd2e085ad698de7972b361985de89c"
    sha256 cellar: :any,                 x86_64_linux:  "236f83b29fbaaba58571fb119eeaf90980add99660d7a08545f7f86a8a3e0cb2"
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
    ENV["HCOM_DIR"] = testpath
    # A fresh update cache prevents the detached online version check.
    update_cache = testpath/".tmp/flags/update_check"
    update_cache.dirname.mkpath
    update_cache.write("")

    assert_match version.to_s, shell_output("#{bin}/hcom --version")
    assert_match "Terminal set to: tmux", shell_output("#{bin}/hcom config terminal tmux")
    assert_match "Terminal: tmux", shell_output("#{bin}/hcom config terminal")
  end
end

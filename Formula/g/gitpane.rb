class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.18.10.tar.gz"
  sha256 "afb9b1bd09918aac779cd5b65749315ea299c714a3014701e93af00624844d3e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2c67665d43fea6b6e56c9b94dce82afd37ae22110fc725c138393d911bf450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a36df99d333b3ecde97f63dd2b170abf27a8b888b4be8ddc2ce0563c365e4ac"
    sha256 cellar: :any,                 arm64_linux:   "10da35605cf65bf8a8ca71910f20c2eb86e6882ee26b1d582bbc743cb5db5afb"
    sha256 cellar: :any,                 x86_64_linux:  "c3381620e31bc0e0570ecf2024fbbcba09a0cb4dc5ba94d5993304c5ecb9cc8f"
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

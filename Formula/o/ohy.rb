class Ohy < Formula
  desc "Lightweight, Privacy-First CLI for Packaging Web into Desktop Apps"
  homepage "https://github.com/ohyfun/ohy"
  url "https://github.com/ohyfun/ohy/archive/b5676863b12308bb68332b7847764f69a9eb60bb.tar.gz"
  version "0.0.0"
  sha256 "2a4d81d68f429cb30b070ed03f1cf02c38b2da4317d5fe91e29be37decc51734"
  license "MIT"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1376117bab8dbb472902a7a7089f12100fc480c5202047c5b3ff45645a129c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "875c48bc2d14e186a7698b7813d1a76c48ed14a5461eeea4daa698dbc0ed7fe0"
    sha256 cellar: :any,                 arm64_linux:   "741c1e2ff35e18426620bcc260b916564dce312ca702a4a15dc70a8206939ab9"
    sha256 cellar: :any,                 x86_64_linux:  "af9accd845777253440fb4249635f70c28c2032fed030eba687be253a8c9d1f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "libsoup"
    depends_on "openssl@3"
    depends_on "webkitgtk"
  end

  deny_network_access!

  def fetch
    # Upstream never commits Cargo.lock; resolve once during fetch so the build stays offline.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"ohy", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

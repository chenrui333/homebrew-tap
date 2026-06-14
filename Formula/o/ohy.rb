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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3c7370daae436e9e67f7728204b117da0b895fd88e5fb10537e2d3b84961869"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5581d1e4c4eb51466f278146d1c850aaa591b8e3624cd2d46cf410fe17a0aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43fca74fe5779dceb361ef888a1cb2d09485136305400bcbba5be78f52c6ba55"
    sha256 cellar: :any,                 arm64_linux:   "ba3d96809980c0640413d30ad6a02d944624b33050789432a817350d2355a7ce"
    sha256 cellar: :any,                 x86_64_linux:  "2e76a439b45ac42ab11ccf176d2e335159c908e1f1d0f72c63a28db7b8928786"
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

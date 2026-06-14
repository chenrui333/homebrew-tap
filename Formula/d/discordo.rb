class Discordo < Formula
  desc "Lightweight, secure, and feature-rich Discord terminal client"
  homepage "https://github.com/ayn2op/discordo"
  url "https://github.com/ayn2op/discordo/archive/77f21369b4d258eaec590d8f1353b6812683829e.tar.gz"
  version "unstable-2026-04-13"
  sha256 "69751db8d3bec788ad76c8da01675315fad8201d3601fbb39349c1c3b4f266b3"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "666008d62a081fd307ea9490f00bdf351febbff41637faa924e9a6a161a83b47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa22e1ffddefb17c1acbde14fc9a92bace7f47fe9b9bf3c4b384f681602b74b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "222692b1aa73873cf4f83083a6f03f31d21118b8ed32aeb457b1c01a47a688c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0acfdc46aa2329d4a7bfb9d296286bc024137f7ba8f4bc6de1af3e60ae3931da"
    sha256 cellar: :any,                 x86_64_linux:  "4f7f785d96beee578bf20cb739e43c8961ce07f9f5a5361a14295ad95ba5738a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"discordo", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

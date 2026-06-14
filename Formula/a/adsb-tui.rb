class AdsbTui < Formula
  desc "Modern terminal user interface for tracking aircraft using ADS-B data"
  homepage "https://github.com/j4v3l/ADS-B_TUI"
  url "https://github.com/j4v3l/ADS-B_TUI/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cfaec5443f30eeaa1908b7587695f219ff0b4cdf6c5967047f145fc50ac7375e"
  license :cannot_represent
  head "https://github.com/j4v3l/ADS-B_TUI.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9d075646e96f5252efa553b147d72c28506bbfeb6378b54134ce00edc2d724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2635bb3617529d36e79a01a89741bfd1cfc0604821b9a3cfa752fe3e44b7071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b1849a07b506170620f8b062ede5dbbe582d8b61121856f7b0438f0b46c23e3"
    sha256 cellar: :any,                 arm64_linux:   "a41c08940e96fc14d498d2618d0339986f6110f7078f05a9cb168a34ff87b749"
    sha256 cellar: :any,                 x86_64_linux:  "35ae6230b44ddb63c39d309bbb158950e3dfcc3641451d2db912f2b6f8bf8219"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"adsb-tui", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

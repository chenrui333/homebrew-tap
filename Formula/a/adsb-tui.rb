class AdsbTui < Formula
  desc "Modern terminal user interface for tracking aircraft using ADS-B data"
  homepage "https://github.com/j4v3l/ADS-B_TUI"
  url "https://github.com/j4v3l/ADS-B_TUI/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "05ce3a5db3b43392c5025b25431e3ff6c314e60be18ae2c852653be5565058d0"
  license :cannot_represent
  head "https://github.com/j4v3l/ADS-B_TUI.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f185e2300135cfde1c11bd43e21cdf3470ffa7b504f11e002c9fecba4aad613"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162e7baa6e4c53df84fc5b5f8466b017adb1baf32a5c988b070f8defa30d3ec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6783413b06bf8dff98ca81955fe6fc03a990c07f12d7be1b015dc2d60c375365"
    sha256 cellar: :any,                 arm64_linux:   "44e95854c10be27430507d73d157bd7bc122cf8406495c6fdba33fa9c1cddb92"
    sha256 cellar: :any,                 x86_64_linux:  "cb175a34887b27524abe3cbbe19de32f6d38d389021fecb745a22c62f9a4e68f"
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

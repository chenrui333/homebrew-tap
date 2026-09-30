class EprofilerTui < Formula
  desc "Terminal-based flamegraph viewer for OpenTelemetry eBPF profiler data"
  homepage "https://github.com/rogercoll/eprofiler-tui"
  url "https://github.com/rogercoll/eprofiler-tui.git",
      tag:      "v0.3.0",
      revision: "d4f38d9ffae421f2322b082ce6841f61f72f6248"
  license "Apache-2.0"
  head "https://github.com/rogercoll/eprofiler-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8a8b74b959537d219bb3d50ae4195905b9f75f9496298b7eb7825161f96cf55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6865867447bd92d8061d70384a6c9c6620bf4efa675a3fc2cfa9865c51e73b"
    sha256 cellar: :any,                 arm64_linux:   "eac450133da40c13b01a9f7ba42ef70c6f9898ac3230c8a846fdd247050a235f"
    sha256 cellar: :any,                 x86_64_linux:  "8766372d9e0307e1f0117322a1921eeec7c1cfb31994ab0e5745783126e42385"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"eprofiler-tui", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

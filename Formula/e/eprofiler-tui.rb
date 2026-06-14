class EprofilerTui < Formula
  desc "Terminal-based flamegraph viewer for OpenTelemetry eBPF profiler data"
  homepage "https://github.com/rogercoll/eprofiler-tui"
  url "https://github.com/rogercoll/eprofiler-tui.git",
      tag:      "v0.2.0",
      revision: "18acde399009a4de4cd8e33a4ee7fb5bbb727d96"
  license "Apache-2.0"
  head "https://github.com/rogercoll/eprofiler-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f71e4504d2578a289ca1ff63456a521641a44bd4d22bcf8d5ddbaa5b3fe29523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16734da814a3886dead237bbbce5f4675d8079972e90aae6774011d2cf2f6485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f9a4bb51bd2c9a8000ecdb9b8a3ac64746da8f24f2166dabacc97bb7f0533b"
    sha256 cellar: :any,                 arm64_linux:   "b10e5f5f37f7b17bc4a698651e86625fb823415f86db4b43bb2784167cf1c390"
    sha256 cellar: :any,                 x86_64_linux:  "30101d483bd54b6e88f128cfa752393583a4c3dc9381d74df345a8bd47ea4b79"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

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

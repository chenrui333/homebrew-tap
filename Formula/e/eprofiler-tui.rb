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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daf5396d51a79db8aafe88c3d47518cde2545b1b18cef83f539d1da8fed0db5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd967296dc7ff099983fb5b25485930da1e408ce8443ec10f107a6130df14b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83692ecf92367b53e19bf5c2c1738f4286f7616c4fe986564d31578d370ae06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60c8283e29a6944542dc3e1dde83bcee445e73e6a182dd0af2be7f3dab0a8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8826189ccbd249ddd5b37630477e3a919196fb83ccac0ea7eb4f3e60d02d10"
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

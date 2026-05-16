class EprofilerTui < Formula
  desc "Terminal-based flamegraph viewer for OpenTelemetry eBPF profiler data"
  homepage "https://github.com/rogercoll/eprofiler-tui"
  url "https://github.com/rogercoll/eprofiler-tui.git",
      tag:      "v0.2.0",
      revision: "18acde399009a4de4cd8e33a4ee7fb5bbb727d96"
  license "Apache-2.0"
  head "https://github.com/rogercoll/eprofiler-tui.git", branch: "main"

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eprofiler", shell_output("#{bin}/eprofiler-tui --help 2>&1").downcase
  end
end

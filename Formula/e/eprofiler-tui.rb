class EprofilerTui < Formula
  desc "Terminal-based flamegraph viewer for OpenTelemetry eBPF profiler data"
  homepage "https://github.com/rogercoll/eprofiler-tui"
  url "https://github.com/rogercoll/eprofiler-tui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "dccca8aee8bd257117d58b7d3abdebfb3fcb0c8b3711498d1ab2ba451d95ebda"
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

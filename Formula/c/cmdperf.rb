class Cmdperf < Formula
  desc "Command Performance Benchmarking"
  homepage "https://github.com/miklosn/cmdperf"
  url "https://github.com/miklosn/cmdperf/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "11add8c4ee1744a0408ffb1e3e4a41d66985c563ebe8b873ea17748a60e7dbbe"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cmdperf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmdperf --version")
    assert_match "Benchmark completed!", shell_output("#{bin}/cmdperf 'sleep 0.1'")
  end
end

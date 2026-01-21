class Cmdperf < Formula
  desc "Command Performance Benchmarking"
  homepage "https://github.com/miklosn/cmdperf"
  url "https://github.com/miklosn/cmdperf/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b5d2d1cad158b9af95e184851a6ebeffd98f81debbb547401d392a11e95c557d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "893f3e4f1e52e128258a526c194f2c7a4bc9023111fc27ccf13e53248741ef74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893f3e4f1e52e128258a526c194f2c7a4bc9023111fc27ccf13e53248741ef74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893f3e4f1e52e128258a526c194f2c7a4bc9023111fc27ccf13e53248741ef74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "161b3c366089d7a4b319e52f1799a2e902a67e243ac0af1d09d07bbb522abd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49082bff4e90a9112d86d0acffcbed0d0fe358bfac93166317639dea4ca1f47e"
  end

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

class Cmdperf < Formula
  desc "Command Performance Benchmarking"
  homepage "https://github.com/miklosn/cmdperf"
  url "https://github.com/miklosn/cmdperf/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "b5d2d1cad158b9af95e184851a6ebeffd98f81debbb547401d392a11e95c557d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9ad948d3c3116d6fb1a1d316cb2605f1b30e08d41cad0add308f2f8546a840"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9ad948d3c3116d6fb1a1d316cb2605f1b30e08d41cad0add308f2f8546a840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9ad948d3c3116d6fb1a1d316cb2605f1b30e08d41cad0add308f2f8546a840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0c6e85acb118b9475faaab690f231f4b41568d9854ea1ceb0f3c89b8ba8e7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75a653cde61ed3768acea4373110dc02143d2c122566575bf97d5632deea0449"
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

class Cmdperf < Formula
  desc "Command Performance Benchmarking"
  homepage "https://github.com/miklosn/cmdperf"
  url "https://github.com/miklosn/cmdperf/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "de876570e2315aee1b7a4f34e39a8708d499921525b9239e459264d84c864dad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "421de75ba1eed69f18bff80bc43ae691c0778e2dd2facc3e83196f5eb2f218b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "421de75ba1eed69f18bff80bc43ae691c0778e2dd2facc3e83196f5eb2f218b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "421de75ba1eed69f18bff80bc43ae691c0778e2dd2facc3e83196f5eb2f218b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82a1a9df53322a75611f160754a0391ab1d49667b2de4490d827472a77a2ea3c"
    sha256 cellar: :any,                 x86_64_linux:  "dc5d5cdaaf4a9fd4b5d79be15491d7c7b33a688ecae53b8ea451d5e4a4e69252"
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

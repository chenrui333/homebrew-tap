# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.12.tar.gz"
  sha256 "1d6dea81458539f77674cf35e1c90ad176b12f2a11dedffbb7013482e2240cd9"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "297892cb77a168318c18d1fd6b5f95109877337c3c5715c058bed66ae99287bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "297892cb77a168318c18d1fd6b5f95109877337c3c5715c058bed66ae99287bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297892cb77a168318c18d1fd6b5f95109877337c3c5715c058bed66ae99287bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb582661794cadc2e77e1719a7119e98ed85e112dd611f9d07d3f64c26e91cc"
    sha256 cellar: :any,                 x86_64_linux:  "1ecdb8789e16aa3b49c2ded69485ef4eba20e2038ea6f4e3bcf7af2d94ad88be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user} -X main.Date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cohctl"

    generate_completions_from_executable(bin/"cohctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cohctl version")

    output = shell_output("#{bin}/cohctl describe cluster test 2>&1", 1)
    assert_match "unable to find cluster with connection name test", output
  end
end

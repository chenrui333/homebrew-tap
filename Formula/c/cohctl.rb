# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.3.tar.gz"
  sha256 "e5285aa467c449098f16ceab38a2337e17418c81ebe10063abb42afccaa74489"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e635d6e2fac080f6aa1696c0ac26c99f7733daff852816b437dd4f2f02a850c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a8abf54a56473a630d15f3487c97b9baa512f05488b40802fa037a00685ccc2"
    sha256 cellar: :any_skip_relocation, ventura:       "bb60bc4013438a43fc75415774b410997a959a4c97ffd7aa195d745f3fb49d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d6b4f12bd7855af4e7e0e45aa5293c9a8d2b6832ad2a419235a90aa5280dcc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user} -X main.Date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cohctl"

    generate_completions_from_executable(bin/"cohctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cohctl version")

    output = shell_output("#{bin}/cohctl describe cluster test 2>&1", 1)
    assert_match "unable to find cluster with connection name test", output
  end
end

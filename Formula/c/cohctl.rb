# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.10.tar.gz"
  sha256 "0721cf8674362e974a55d41a9317882dad7f0d6ff0081947f4befe4fbe708b2f"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82e4b8b38ce271743fe5d12eb6fa2d67c08cbc7ccd61f0d3d9546014470e14cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82e4b8b38ce271743fe5d12eb6fa2d67c08cbc7ccd61f0d3d9546014470e14cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82e4b8b38ce271743fe5d12eb6fa2d67c08cbc7ccd61f0d3d9546014470e14cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050a4cc7d1c21d60934f875fbe44098b9230d1b2a84ecea1b3a5fb1016b741d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77254de1953a8f3d3c244d9c1c79621d80865a1e812b3583864d2abd55ec81ab"
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

# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.9.tar.gz"
  sha256 "cca36e06a11906bf430505088ef14114439149f5a0e22729a76e64e7e2885c38"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3f0118d3721d1a3dad0a1651aa58ffa8c0dac522937b6bb9f94b3e31c0a83a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3f0118d3721d1a3dad0a1651aa58ffa8c0dac522937b6bb9f94b3e31c0a83a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f0118d3721d1a3dad0a1651aa58ffa8c0dac522937b6bb9f94b3e31c0a83a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "768b62e88826f49fbb054b9a5b3a348a8bb63d1ef56604f33d6742f4b15014e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40026e97b822a4b520e86892ae873e0fa9845ae1522107b9bbd7ae77817560a6"
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

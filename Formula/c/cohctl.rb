# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.7.tar.gz"
  sha256 "dcdaf15ba65698473cd22d6f093f790dbca1dac1d71d7088fa57110228892245"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d71afbf0e4784360e8f59fb7b4a4155c905b50f7b9c2f6b62ebf8d1167e32a61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d71afbf0e4784360e8f59fb7b4a4155c905b50f7b9c2f6b62ebf8d1167e32a61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d71afbf0e4784360e8f59fb7b4a4155c905b50f7b9c2f6b62ebf8d1167e32a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe24e117be5da34b7994f689cd45d63f33bb7c252d56137e5d39edfab205804f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d23300b736494e4b0ffb7e1ad908880283db79e89819e7368ca153568a72a4f6"
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

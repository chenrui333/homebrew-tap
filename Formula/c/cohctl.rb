# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.8.0.tar.gz"
  sha256 "7f97ce53919aace43d0b115746f48fef6ab6381bc77c7b6b1fa24c449c11ae2b"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

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

# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.4.tar.gz"
  sha256 "cfe2b2c6405bcf094e210a5fc612d672b1982ae9909b949bb048a2b54f04c4eb"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cce011645334403885b978d35fdaaec29b91c177196654bb0c597d74f3f5a74d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce011645334403885b978d35fdaaec29b91c177196654bb0c597d74f3f5a74d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cce011645334403885b978d35fdaaec29b91c177196654bb0c597d74f3f5a74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e92b8011ef0d47216f516752cfb967e84d3dc307bb10a779266d3aa30fd35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee4d912614a6aae236d7ce31cd70321acd8fec48f27792085c0e2502185581c"
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

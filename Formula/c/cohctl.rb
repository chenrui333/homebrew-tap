# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.9.1.tar.gz"
  sha256 "b3798d4d21c2ffab2d80085d21a6ec714742164f3c895ffcb8793258c51f4766"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74959dd92678ffe8b78c9dc584d1d5aad6da93263e7d9feaf5ae95de12b4ff27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48ee871339b1ddb1c7419550f751ce2a5c24c83bc6158687b7fcfe354a680309"
    sha256 cellar: :any_skip_relocation, ventura:       "582a03f315a0ee49246f103a6bca6cfc25c878c7916a3dc20ecc4d773aa7bcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ff2f0a2d3a16708b8776e97dea6e2d78790a33bddb81391196e5036d2f1772"
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

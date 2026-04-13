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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08865807b693c63f2ce2867b34a54454625d3cc71d9b294ea3fbe9abd279b8ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08865807b693c63f2ce2867b34a54454625d3cc71d9b294ea3fbe9abd279b8ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08865807b693c63f2ce2867b34a54454625d3cc71d9b294ea3fbe9abd279b8ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d99a5f7a4d09314556449942807d9e0aaf12697ef4ba493203cc814176292f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc7e5dd8108359635e43db524b42086158f4dd11a350c2b5ded5fd6871e2f9e"
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

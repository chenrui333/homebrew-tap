# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.5.tar.gz"
  sha256 "4474747e8e09a5d44ef1af9150cfed5a0e93a61075f04125b9d84036f92f6cb9"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2907180cb293e5922e009b669a64b59e217082949e00cb54d0b1afc0bbf938a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2907180cb293e5922e009b669a64b59e217082949e00cb54d0b1afc0bbf938a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2907180cb293e5922e009b669a64b59e217082949e00cb54d0b1afc0bbf938a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e7b5cfaa04665a67dc8b23359fa9027a6a46ced6b51694a84414fc4348893e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c28aa790a0a4631ca877c3aa4679f5845f46cb9b022216dc243acb4bc7d87e"
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

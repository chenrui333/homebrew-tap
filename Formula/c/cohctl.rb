# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.0.tar.gz"
  sha256 "ddac23630ff1fe9416c0ddca9ed785baa6d884b79cfe515b853c3a6d1595a61c"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1740c441b79e8d07d183771e4df382371d87a580348db6cbf9c83f060d2d6c71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fde0922e256985c916c36e641b1a2d298a89e11604e30176de131bcbfb33e8e"
    sha256 cellar: :any_skip_relocation, ventura:       "e90907872d8a93d1812f07217b0cd55c74389171a72986cd5850b8ace55072de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62b78f379ec5c255a6f7e85682e65a7f161f3f85e8bf60562f53d000c7ba3c69"
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

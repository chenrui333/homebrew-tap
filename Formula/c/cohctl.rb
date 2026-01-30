# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.6.tar.gz"
  sha256 "a8f0fd6ca2143b960e5a48ef5c7b61762ad5d395a77415045918d902b767095f"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72141734e4378ae139272745c76212cc9245e6775b027eba5ea9d010a77c7078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72141734e4378ae139272745c76212cc9245e6775b027eba5ea9d010a77c7078"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72141734e4378ae139272745c76212cc9245e6775b027eba5ea9d010a77c7078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ab685887fdc2166f07aa61525396fec5cc47de4589cbe0f52f193456191d51c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27aa2883225aecc748cb521735461c189d6a7d9ba029bcac4229583f9ac2f825"
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

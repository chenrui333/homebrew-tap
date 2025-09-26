# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.3.tar.gz"
  sha256 "e5285aa467c449098f16ceab38a2337e17418c81ebe10063abb42afccaa74489"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c89e5b589cf3ea9fa83571630fde87125096d0911053d3dcb5ed46afe37d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08549be70a0cbd1d972bbdd5a0bfe028c12912687212db969b14102f7c2b66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88fca08e4f1332f8727ddb2e1bbccc3a316db129c1ac36142f4c65351f3068b7"
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

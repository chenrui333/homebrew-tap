# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.14.tar.gz"
  sha256 "ca39bdc097ddddbe05b0f2e1fe0580ca75d4c6070b392c3a94077321229d19f5"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad72261ad843277b8738e0e397c2dd6e711782794e12ca376a550ee7ce74e3a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad72261ad843277b8738e0e397c2dd6e711782794e12ca376a550ee7ce74e3a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f47493714473ba71a6a1c582722128d93fe6e15bb3f792ac396b4e6d741d7969"
    sha256 cellar: :any,                 x86_64_linux:  "0284f8af964d7a57baf4f5ac794a8599dbb8605b8d8d5a9113f6b447428e5579"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

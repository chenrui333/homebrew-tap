# framework: cobra
class JiraCli < Formula
  desc "Feature-rich interactive Jira command-line"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "2ac3171537ff7e194ae52fb3257d0a3c967e20d5b7a49a730c131ddc4c5f6ed4"
  license "MIT"
  head "https://github.com/ankitpokhrel/jira-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a70d21a10ac1e7e25b06004f2f6516630c3f32114038302cd2e8656e8088928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7269fbcd9c22640f16fcc15c46b086b51b7b3b0522221cfc18dfb2e646c6673"
    sha256 cellar: :any_skip_relocation, ventura:       "6ed7f0c670c50640d6fc2dc056143ec2284130f148010352504a39d0e3378c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee58d3631d3ca83d11deb9d674400ce3de428c1e179c53d3671d404a30edc176"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ankitpokhrel/jira-cli/internal/version.Version=#{version}
      -X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=#{tap.user}
      -X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=#{time.to_i}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jira"), "./cmd/jira"

    generate_completions_from_executable(bin/"jira", "completion")
    (man7/"jira.7").write Utils.safe_popen_read(bin/"jira", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jira version")

    output = shell_output("#{bin}/jira serverinfo 2>&1", 1)
    assert_match "The tool needs a Jira API token to function", output
  end
end

# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.13.tar.gz"
  sha256 "f5078e1145b74f1103dcde1fd21d0d68386d23dd3c0594cf76573ab3401e9dae"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965aa72e463b8b78e92091a6735870ed2decd8b73401cce6b93812c9e0fb49a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "965aa72e463b8b78e92091a6735870ed2decd8b73401cce6b93812c9e0fb49a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46efc91376be8669aebe151f1d27474ee29507ab163faf2234bc3f1d4a36c367"
    sha256 cellar: :any,                 x86_64_linux:  "8c8c6c9d3972f0ce9842e9bb02ae30013c9cc5daed97995d059083604baff49f"
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

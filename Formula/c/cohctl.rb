# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.9.0.tar.gz"
  sha256 "4e976e029407e7e3e6e99335aa18a4e7eaa105ff118ca0c28e054f0ea3799519"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b7e50df157aac6e8375dc8b394fbc9f76ef7245bc1a399afb444ec0b7c211ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6445546a9c211a50b409ce17ff41abbe35bc0f81892b91909e3e6a395fa746d5"
    sha256 cellar: :any_skip_relocation, ventura:       "a0774f041f86d424988e9ac343a3115210ba52f0e68eb1f3922693a766e0c846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ffa7978d6efa5ceda8918628f8429b63b7e6f6ca1ccf05ead17e128002c636"
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

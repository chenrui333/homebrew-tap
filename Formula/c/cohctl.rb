# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.4.tar.gz"
  sha256 "cfe2b2c6405bcf094e210a5fc612d672b1982ae9909b949bb048a2b54f04c4eb"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ed9e01cb444b0beb7ab2782349f6a02114c0b9d234f2f9e98f5cee8e0f57b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed9e01cb444b0beb7ab2782349f6a02114c0b9d234f2f9e98f5cee8e0f57b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed9e01cb444b0beb7ab2782349f6a02114c0b9d234f2f9e98f5cee8e0f57b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb99b25f7a609ff038fd2d91a54e9b874dc823b2e30123f9e60dd9bca35360da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d341996b062faca346f3b9d6929fffb1a14d06eb2173dcbef73c4da42781e60"
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

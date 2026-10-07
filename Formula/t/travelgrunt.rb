class Travelgrunt < Formula
  desc "Package manager for Terraform providers"
  homepage "https://github.com/ivanilves/travelgrunt"
  url "https://github.com/ivanilves/travelgrunt/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "ad52294a93d7a06e2c551e0b29b03300790c91cf547440547da48e4406c0af0c"
  license "Apache-2.0"
  head "https://github.com/ivanilves/travelgrunt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c1ef82e252fd289597bc7b6269495aad448b35576ba1b6b599b2db2b8895b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1ef82e252fd289597bc7b6269495aad448b35576ba1b6b599b2db2b8895b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8116becc16d73ee2fbda3e22ab336270a983b48951e140586ee5437ec14cd63b"
    sha256 cellar: :any,                 x86_64_linux:  "c9e4a060168edf338ecfce4a7900bdb44cdfe66eb93d769ab4f2e576501dbcb2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}"), "./cmd/travelgrunt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/travelgrunt -version 2>&1")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "invalid"

    output = shell_output("#{bin}/travelgrunt -top 2>&1", 1)
    assert_match "no such file or directory", output
  end
end

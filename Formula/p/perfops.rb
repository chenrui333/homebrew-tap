class Perfops < Formula
  desc "Tool to interact with hundreds of servers around the world"
  homepage "https://perfops.net/cli"
  url "https://github.com/ProspectOne/perfops-cli/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "05ace04f3dc3ff76e49e4b2971ebb9ded8b8e1cd91308984c38e47da2e0a51c2"
  license "Apache-2.0"
  head "https://github.com/ProspectOne/perfops-cli.git", branch: "develop"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f43188798eb363de65af03976b7191a685c11cc3f70d8a5940e2a8e233b42287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f43188798eb363de65af03976b7191a685c11cc3f70d8a5940e2a8e233b42287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4fb40fb41ff2d162036ef11b2309ad6941f9cd704d042b6edaf831f72f3781c"
    sha256 cellar: :any,                 x86_64_linux:  "4286c850321739ac98828c0e262b4664733912f20a9120eaf4c1a26fb34d9dd2"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = %W[
      -s -w
      -X github.com/ProspectOne/perfops-cli/cmd.version=#{version}
      -X github.com/ProspectOne/perfops-cli/cmd.commitHash=#{tap.user}
      -X github.com/ProspectOne/perfops-cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/perfops --version 2>&1")

    # Measurements run on the PerfOps API; target validation happens before any client is created.
    %w[ping traceroute mtr].each do |cmd|
      assert_match "no target specified", shell_output("#{bin}/perfops #{cmd} 2>&1", 1)
    end
  end
end

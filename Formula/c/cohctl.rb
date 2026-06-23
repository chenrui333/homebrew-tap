# framework: cobra
class Cohctl < Formula
  desc "CLI for Coherence clusters"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/oracle/coherence-cli/archive/refs/tags/1.10.11.tar.gz"
  sha256 "cd7687dba4b930d0f3771bd1aeffce5a8831644e0b7aac81211fc092c070669e"
  license "UPL-1.0"
  head "https://github.com/oracle/coherence-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfe57cb4b9791cf1571d57ee7f8bab9ce26d3ca968124b6e4218f151a179a0e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe57cb4b9791cf1571d57ee7f8bab9ce26d3ca968124b6e4218f151a179a0e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfe57cb4b9791cf1571d57ee7f8bab9ce26d3ca968124b6e4218f151a179a0e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf26d7e01acffbae9fbcd9db484a50655fcdf3620d5eab7a2d76dfd8cf2277a"
    sha256 cellar: :any,                 x86_64_linux:  "57c6308fa4e1351dff997389fc93b894f0a54b41ce504961748d7f025f3d747a"
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

class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9bd34b416eb9a15cb97fff1f10e90520d999350c8a8aa9373c7fdecb325c7297"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98b3cd62e9c5dbdf3e45fb7f6d391ec862e85aa1374f479e36c03f2264981eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b3cd62e9c5dbdf3e45fb7f6d391ec862e85aa1374f479e36c03f2264981eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "419e46abed9f4e2b342bcf77cbef220814dd5c310a954c3ca0d767b66f1da2d0"
    sha256 cellar: :any,                 x86_64_linux:  "e3001877847af5eea0a817fb39033d024696d66724af747b52212c6d4f47d16d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/nobl9/sloctl/internal.BuildVersion=#{version}
      -X github.com/nobl9/sloctl/internal.BuildGitBranch=
      -X github.com/nobl9/sloctl/internal.BuildGitRevision=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/sloctl"

    generate_completions_from_executable(bin/"sloctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sloctl version")

    assert_match "default", shell_output("#{bin}/sloctl config get-contexts")
    output = shell_output("#{bin}/sloctl get agents 2>&1", 1)
    assert_match "Both client id and client secret must be provided", output
  end
end

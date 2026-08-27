class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "c4a806a000a68f512021b0642ca296c9b82cf66b079728d7e6aae195bfaae969"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167c4d3ee2d5ba49be18cb60516b618cf07e090472576a9f9699384e4fb869cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "167c4d3ee2d5ba49be18cb60516b618cf07e090472576a9f9699384e4fb869cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167c4d3ee2d5ba49be18cb60516b618cf07e090472576a9f9699384e4fb869cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb7eaf6fa15c570c8b3ebd746a725cc0a6eab4bb9880cf487e7d32f3cdbedd64"
    sha256 cellar: :any,                 x86_64_linux:  "2b3724ee0f37ef1cbc77037e887c7469d47cbdae53b578e40cca2ea494db74dd"
  end

  depends_on "go" => :build

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

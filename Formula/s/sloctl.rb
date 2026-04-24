class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "4d3e40ecdf32da44287a51c6ea8b14b33cf3a11ce3bc7acc586ca2757576ffcf"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbf3764a7b6ae1698887ecaf3027650d475901d4048cf6ac61ac536d5e921a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf3764a7b6ae1698887ecaf3027650d475901d4048cf6ac61ac536d5e921a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbf3764a7b6ae1698887ecaf3027650d475901d4048cf6ac61ac536d5e921a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1b36913f2700c537e58addb0afa66e9ece0681dc24af13c01e65a01e4ed445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c82d32acc3ec2857a465929345a9a88088f09c9c683c7a12ad96147461c18667"
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

class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "4097650abfe82bb3d0a8cda46584f24ce8ccb91a7555b1f0ad1f0593f168c45b"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58510792a29352c2e106e4def71ece69e8b1f08cdf6863f5d160090b44e296fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0648c4b1424a94a3ae5b0638f65cb19b5563ac8b019b83c39d9ffa181c3fa729"
    sha256 cellar: :any_skip_relocation, ventura:       "5cedcc5f1146cb7c53b3c3bbbf764389d94a6f260f4003f81bff99c891f4c74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c2a608860955f1d95ff2e169bd09cc801642903dd8e5eec115157203663cf3"
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

    generate_completions_from_executable(bin/"sloctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sloctl version")

    assert_match "[default]", shell_output("#{bin}/sloctl config get-contexts")
    output = shell_output("#{bin}/sloctl get agents 2>&1", 1)
    assert_match "Both client id and client secret must be provided", output
  end
end

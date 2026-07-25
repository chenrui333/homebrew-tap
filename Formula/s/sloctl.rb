class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "e520d0252e531fb28345849f59d963c8c6d1fffb73dff4f25ff60c0aa3c872cf"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d1a1e4dcaff5c8fb71f462e755d5c3d2176cc23c33d8a652dbc853f94d4ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d1a1e4dcaff5c8fb71f462e755d5c3d2176cc23c33d8a652dbc853f94d4ab9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d1a1e4dcaff5c8fb71f462e755d5c3d2176cc23c33d8a652dbc853f94d4ab9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ac1f9295e99a7b6f373eccc0b0790ca8cde5bcb6c92ba3f67b542d49d2bc12"
    sha256 cellar: :any,                 x86_64_linux:  "1ae545988abac79ee13fd88409f582cf1b9aa85a8dfd2d62eff07989a98a92ef"
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

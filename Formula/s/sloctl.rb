class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a196643b7757879d050c9ecd102ed4506990f6d8c7bce4a4ea2422b3084cdfc4"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c54be877a7a63e723e7c1cb39a82a3c8b6c9b35bd835214e830a8b46ceff944f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c54be877a7a63e723e7c1cb39a82a3c8b6c9b35bd835214e830a8b46ceff944f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54be877a7a63e723e7c1cb39a82a3c8b6c9b35bd835214e830a8b46ceff944f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f04cc1a890bb73c57c4a7d697d0792652e3cc09323ec0f08cb266cdf6d097d4a"
    sha256 cellar: :any,                 x86_64_linux:  "afe3ce71504d1bf2dd8c5107f73afbe0b8bbe29fe51c87583e3178c43a7fe1a8"
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

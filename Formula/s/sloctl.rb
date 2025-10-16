class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "5f508f1a4dcc2d7666bd43fe0b1469a86a9a7d46a40897c55ec6d37bae0d9d1b"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be92987eca4ce63506564b7c20d3bfe0ca28d9ac5d5d5406db2906b34a7b6f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d15833f949a68e1a5fc65a00d1e758036573992461265dc4b9294a1deeac35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fac92751d7eabd57f4349a3fde6ff58e0ac90592c740b46b39fb328d706795a"
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

    assert_match "default", shell_output("#{bin}/sloctl config get-contexts")
    output = shell_output("#{bin}/sloctl get agents 2>&1", 1)
    assert_match "Both client id and client secret must be provided", output
  end
end

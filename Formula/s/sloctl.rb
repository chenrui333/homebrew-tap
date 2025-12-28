class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "7965f3edcfe1256c184aa0566ca660e78dece29d27f3ebb7e13c69913081aa4b"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd7e077a00484faf254e7bcae535ac3405d332d6a2e36206ce95e5302c400254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7e077a00484faf254e7bcae535ac3405d332d6a2e36206ce95e5302c400254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd7e077a00484faf254e7bcae535ac3405d332d6a2e36206ce95e5302c400254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49461171f40784703cdc783cba4ec4abd413c4f6d45314414d06234b8c354855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bbb1d2bfbb8ae0ad69e61025cdaa7cd6e104c17da2ebb126a72cc24871d0691"
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

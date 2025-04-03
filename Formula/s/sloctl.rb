class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "2806b5a4e68f7255fee4e4ec8bc12a7aa66c22a559d77589c5d3bc3d88788692"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d945d49893a72a451fbbd3a63d745a54de9da30c3afa073e4d52e3c6dd235b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be8dc3a664e1f4df835b1d1b127715fbdd9e8c07e4c87a5fb7001ad4808b4cc6"
    sha256 cellar: :any_skip_relocation, ventura:       "7dcc30ec581a916e31218ad0540e64b647f454d70e3fc1c2eef192dab8a50798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bc379e45dafcba38b46eb7e42bb15736b217386f00dc794ce6621bf3cbef57"
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

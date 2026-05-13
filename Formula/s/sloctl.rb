class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "56679e47cc668404db692c1a683610a95374a2f4282c061484fef93df4097998"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6807a42468256e913ac56f15fef78f160b5eb3bd89857b338efafb76e55817b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6807a42468256e913ac56f15fef78f160b5eb3bd89857b338efafb76e55817b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6807a42468256e913ac56f15fef78f160b5eb3bd89857b338efafb76e55817b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6e8f1461186d95da129516d50a9684f1c97d1ea14c41b736f4b3e1a871988f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5ab41ff9dce553fc3897d23d9d5d3c62cd2aedfac109867f79b01ccd7ddf50"
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

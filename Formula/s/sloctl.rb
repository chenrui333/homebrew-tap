class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "5d1f11794680918f1a0aa77732c6441f37e7e5035abb1f088484c6b4f383cdbc"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f54ba6380764838d3f27c0418a9963e0b90a5f3f18357bafe2ab1b8f1d85c54f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54ba6380764838d3f27c0418a9963e0b90a5f3f18357bafe2ab1b8f1d85c54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54ba6380764838d3f27c0418a9963e0b90a5f3f18357bafe2ab1b8f1d85c54f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5c80921c3f5a6e393917a98bd22de4ed9f9068bccf9abe159490b899aa644a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d16db6925fb8524571fbdbe21a13be1e108c463bc5d3f896f15255596273b46"
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

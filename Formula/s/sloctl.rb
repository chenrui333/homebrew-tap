class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a4a6842a239029867f97ee8b1524e6a92735e615f66f2babbf6b30d6e283bdf3"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dde6877dbf908b868c8cd160e17a7106ec2438d4519e44c43f0fc0de1b1ee0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dde6877dbf908b868c8cd160e17a7106ec2438d4519e44c43f0fc0de1b1ee0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d11d55050ce7110d036721f80ff0d7425c0e351d8f5a46461f27c1f196f2809"
    sha256 cellar: :any,                 x86_64_linux:  "4f204891f80375ea944e8dc2e7501cfa11ace0a4001e53410dbc1b1126c1a141"
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

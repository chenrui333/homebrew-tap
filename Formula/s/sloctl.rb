class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "e520d0252e531fb28345849f59d963c8c6d1fffb73dff4f25ff60c0aa3c872cf"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "664b97d33d76c27b44d911c1d292d9da3372bc849c5f74feaf82249ae9520d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "664b97d33d76c27b44d911c1d292d9da3372bc849c5f74feaf82249ae9520d93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "664b97d33d76c27b44d911c1d292d9da3372bc849c5f74feaf82249ae9520d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc05be90ce49e08bb9e3c3683527e49e964611a87fab2b93ca3061d89f89b19e"
    sha256 cellar: :any,                 x86_64_linux:  "4482a99391460a0592da007ac9bbfa0dcd2069dc1c2ca5297bd84783ec035aa0"
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

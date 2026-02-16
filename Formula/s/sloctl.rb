class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "1d4aa3eccdff3b9e1725b860746f8472df3ac0adce086f4670267d3199e37fd2"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fac195ee4dbe25a4087a8ce69523aab71f024a624b59cca7f58e300344f4506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fac195ee4dbe25a4087a8ce69523aab71f024a624b59cca7f58e300344f4506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fac195ee4dbe25a4087a8ce69523aab71f024a624b59cca7f58e300344f4506"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704303bbbd3f8da3f33b4aa16cc732bc52bf2303e406811ed4c3b43c7cd7c155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2267ba21c82114d27c9b8e3ec0f9300b8a312c2f15a86bf91d4a9049e544fc5f"
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

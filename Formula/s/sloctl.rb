class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "cc8eaf6fc3b362ab67edb37f6a95bb07a5ca9227d340e4315458f484d17a5cc4"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ca65045226d77fb509b047c809354065eea774af132b9044560d852b54b0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cb2a32bde658ca3a6999f3c5c28d841d30784976175da9167429642f83b3e8e"
    sha256 cellar: :any_skip_relocation, ventura:       "51180c7d6c45089677ddb195bdbe5530f13c51f54a4f7f2c7a63395a8019ec85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13079678a7078d5a3e3a651ed43a0a044661f556a8c112f3245456d5a73824b5"
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

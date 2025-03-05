class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "6e7211054825a420490272d298fff6b33c70eecda920ccaf20f0032879d36e75"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c938e85295132fce211cdffe7799e8f83de04cc67b6be0a2492b28e2224e0f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87947d9d6a7724b7bf63931ff500ce4ef1945b5f1da94dac89df49efcb8b6e72"
    sha256 cellar: :any_skip_relocation, ventura:       "b67e9357dabf9fbd59b93945e9f24f346bfcb1168b8cf467c612f01762abf6e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9f7c86bfee584f3cda7e50e7abc128abbc7637583460f69e9e54baf18689353"
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

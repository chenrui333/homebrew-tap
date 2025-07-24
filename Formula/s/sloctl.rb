class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ec22d84763ec6e801a524a35e841598415e3e99c26c242f542fc0c9eafc6751c"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "376e043c11b323f8dcc9480cc14ce1722c4bf8f75f650cc141f631d8404f4bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea52f7b87575bff5bd8be17eb7a08d1665c630e1963a780eeed64292f3535a8"
    sha256 cellar: :any_skip_relocation, ventura:       "39ec30ba16e66290211b98a9cbdd6056e04c34297b1f08ce64d9c1b636c1fa92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d953d86a956f65f7d6d29bca1b878c70b7452467091b2e8ee27867c552c08352"
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

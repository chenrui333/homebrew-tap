class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "69d90960e0c4aedb95c1cc9d8c1828fb102412048f9f3d82f2e17cf2decb82da"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43d0053fefab1a58b7ba8cced6ed28095e1f87f04c3f0745fe563007140dc961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad4b040a7cb87f067fda08377da7b8710d017a6a4b9beb72f72f891ed7b865b"
    sha256 cellar: :any_skip_relocation, ventura:       "a5dd51546a83b31bffc88b46c92074a4657c444fedb453bc118ad964bf29a5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c720c36dcf99124edf143a302d324666fe5c0cccd56209eb95b3b1cab17077"
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

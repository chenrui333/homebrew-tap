class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "56c95d27c024f7c81868adaee195b409c364c27c4aaa603ea6daaa40c97a32de"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8330b23cf5d24b81f54381125813a6cd10076595f8206f918c1bcc53ddc502e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ae372221b3c60405d1a013649fdea1764492242f6c7bda2b901a29a539f22a3"
    sha256 cellar: :any_skip_relocation, ventura:       "1727a63564fbc91d9a643114505d219d918a7b4725cb42d9ddc09c0d91948217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6cebc1a108ad819ff18ef34b7f82a6968ad434cde974ecd4957f56cafbd940"
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

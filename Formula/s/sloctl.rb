class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "3c7d8b800744f0cd40c321ada68e5cf1d01964898df6aef045b6e0be67dc0567"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b79a9a1154763d74e6e60453919d0ce6bfacc504fe60571fc6b9a9b6a16269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea09503e898ec8acafc3dd5eb8b43f6ee3fdc9df19d3be2bdbc8faef82f3426"
    sha256 cellar: :any_skip_relocation, ventura:       "df5b3781f09b6e5df72a4d0b42824a156386a408e207d7330c649ed633644448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9519d156828f47208a2a9b41037a06169b5516838e061a4682629866de51ec36"
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

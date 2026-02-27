class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "a6695ed5f58619b20da4e4e7ad07e27c478bc99f279930d8f30a3a1957d08f7e"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f54261bef668f714346c7d9a60af3a7a448cd8c1f5ef40e1cd4050b9730729cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f54261bef668f714346c7d9a60af3a7a448cd8c1f5ef40e1cd4050b9730729cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54261bef668f714346c7d9a60af3a7a448cd8c1f5ef40e1cd4050b9730729cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35c3193dd168634a39c4b477a7d910dd3a826feb1702e9870546de8cfc6ba28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8a1d2ad1d61e311593631af86b1910d150f14e2b21b46005ec2d28ad7b4be9"
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

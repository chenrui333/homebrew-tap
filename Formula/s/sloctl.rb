class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "fc0213e874bc59c506750e33fa1f3e48dd1bdc14b04162d7ec9a7f72b06b7909"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da3b79cfa34fbf261dda3675212f2a790791c6b35c3bff69a7dfdd00c2b34d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da3b79cfa34fbf261dda3675212f2a790791c6b35c3bff69a7dfdd00c2b34d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69fbc888e270212e29db99e17e183a58fee7d0476cb0b5ad674ff0a0cd310ac3"
    sha256 cellar: :any,                 x86_64_linux:  "4339d4e00c0d4ae81866c7d586f49986719453d84af3db5fd87f4d0daa43d9d3"
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

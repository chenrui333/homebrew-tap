class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "493aa0768f6225a4688385ec8f8390b3bc71b73b78cf71bba3e2f49ea4f1e55d"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0d3e17fbdf48f61cc0f97d805a4948f9fe702a6c8bf26be081cc87814967bfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d3e17fbdf48f61cc0f97d805a4948f9fe702a6c8bf26be081cc87814967bfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d3e17fbdf48f61cc0f97d805a4948f9fe702a6c8bf26be081cc87814967bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e703e9ebad162703223f1ccac0c759a09a647aa7d4f243605659656721658b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48c5e68ca56beb0abc6b0d2c0e913d016aaaf565718350a6abf62fceac2c598"
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

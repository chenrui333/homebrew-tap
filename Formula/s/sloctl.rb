class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "4d3e40ecdf32da44287a51c6ea8b14b33cf3a11ce3bc7acc586ca2757576ffcf"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f349ff878b44e4dca6960e4ef4623893e6226a20696c5f0a5e8256f307ecc5ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f349ff878b44e4dca6960e4ef4623893e6226a20696c5f0a5e8256f307ecc5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f349ff878b44e4dca6960e4ef4623893e6226a20696c5f0a5e8256f307ecc5ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a70612948feaa74b4a8dde370371195b06e3da851ba448c2390d5963b022864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb3297cc0a5cb4220d4e0e7eff6ae17fdb917605dfa82a5ba152562134b1e03"
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

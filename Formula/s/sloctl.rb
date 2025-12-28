class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "7965f3edcfe1256c184aa0566ca660e78dece29d27f3ebb7e13c69913081aa4b"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2361b7201071ecc03dff4ca4b5879f5d4e489442e634070c4defe0d5a343256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2361b7201071ecc03dff4ca4b5879f5d4e489442e634070c4defe0d5a343256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2361b7201071ecc03dff4ca4b5879f5d4e489442e634070c4defe0d5a343256"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d38935f13a5f46d2a0ff9bdf5bcf86e93988b52458975397551936eba8a64d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd8361d270b6fa6be96f34a2b9bf24dea54741b5cc4a6fb440ba2a6225d6828"
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

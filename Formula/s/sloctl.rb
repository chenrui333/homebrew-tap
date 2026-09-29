class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "54c9eb4e50fc46cba5678961f5c92964609e37f28db565243e7016b95adebb2c"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68d4a5dfad960928adf82fd0a339dd270ceb6c5a79026ce9dc232d5f484ff181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d4a5dfad960928adf82fd0a339dd270ceb6c5a79026ce9dc232d5f484ff181"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb09d1159736da1f891e4b34bd34fb2dbcd266424f15160a1409b4763d0ec5ee"
    sha256 cellar: :any,                 x86_64_linux:  "c3cd56328e598961c4acc8bba618c464b53b76ff0b2dffd053be4e87a35cee1f"
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

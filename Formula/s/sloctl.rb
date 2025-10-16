class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "5f508f1a4dcc2d7666bd43fe0b1469a86a9a7d46a40897c55ec6d37bae0d9d1b"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e56027c7b04ea72448159d9d67d5f5ba5189ef927abe16dea6904e757c727633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56027c7b04ea72448159d9d67d5f5ba5189ef927abe16dea6904e757c727633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e56027c7b04ea72448159d9d67d5f5ba5189ef927abe16dea6904e757c727633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e75466d5cc22ca28ee4b64fda56c21568d890576f3b7fe0ef1d3c0e3cfeb0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9042472d7adb089f4a3a8dff2106243e0688ccfd51d176b01effe6264a8ac16f"
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

    assert_match "default", shell_output("#{bin}/sloctl config get-contexts")
    output = shell_output("#{bin}/sloctl get agents 2>&1", 1)
    assert_match "Both client id and client secret must be provided", output
  end
end

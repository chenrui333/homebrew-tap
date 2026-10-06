class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "54c9eb4e50fc46cba5678961f5c92964609e37f28db565243e7016b95adebb2c"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd1f4b45c3d812679ce03b803fbe653e40f353c17c4b8049762c4137ba670896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1f4b45c3d812679ce03b803fbe653e40f353c17c4b8049762c4137ba670896"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcf9815856fcbfd352bce57cc630d86bfb8125381094db4e7bd48a7fb0014500"
    sha256 cellar: :any,                 x86_64_linux:  "3ddad89dd2a069641e8073c88e1ba6c35053f19e6e4dbd97f5319960b8e62adc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

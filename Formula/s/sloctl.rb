class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "d31d3462c11deceec64e0eaaf9f7d0167de65d843959f5fc89ab4074a2663afe"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f3a37fd0dce6dea7295b5a904ffc80a4f8208b7990d420480d2dee800ffa55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f3a37fd0dce6dea7295b5a904ffc80a4f8208b7990d420480d2dee800ffa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f3a37fd0dce6dea7295b5a904ffc80a4f8208b7990d420480d2dee800ffa55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e462231afd35f4a035862123e4d2f19940fbb074098196a3b26fdc2b615e7c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b57b2da30aab09adbcf18cddcc2fab1695e96643aebaf684c67dc3ec44b1b41e"
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

class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "9bd34b416eb9a15cb97fff1f10e90520d999350c8a8aa9373c7fdecb325c7297"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e11bdc031639e3bef5c4ddfc6fc8f9ccc0d73100deb70aad9afb931284a9736f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af956d16822b797db3a33612d686a122ebaa6d80c8e070f9b0c71ee663d65bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af956d16822b797db3a33612d686a122ebaa6d80c8e070f9b0c71ee663d65bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "172d856b428e50dc7e5b11533dff34864f34ceba38ff3306d3485b3b13f57d5d"
    sha256 cellar: :any,                 x86_64_linux:  "5f9045a0b9957da5fea436f115e6e3f1eef09965cf269beac697431a1166773f"
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

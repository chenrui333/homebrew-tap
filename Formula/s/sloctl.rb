class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "ad93a96eba3843f42d5b44a7e7754093c2229cd03cf1ce347cf3f1279e0cfdd6"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "736f087ac9a8e6ca426d14d561da1c0e37cc97fe869a66d249b247810da3503a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75428d0392e2fa3095361e235469ab671a0af7f3c7d4308b97abce5ac475ae9"
    sha256 cellar: :any_skip_relocation, ventura:       "bc57ee644c821313a8351871038cc5498d3d98fd4cc8c0215c6d0ccc964f8bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b444a2bfddf0b2b1e41d936ae3cb2b043daa77f2370d10e96a6b063ecb2545"
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

    assert_match "[default]", shell_output("#{bin}/sloctl config get-contexts")
    output = shell_output("#{bin}/sloctl get agents 2>&1", 1)
    assert_match "Both client id and client secret must be provided", output
  end
end

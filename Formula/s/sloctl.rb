class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ec22d84763ec6e801a524a35e841598415e3e99c26c242f542fc0c9eafc6751c"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbe03768c3f9d7b52b5393ebcafff188e54088609d1751c66333438a1060f2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256a25b171895079a517bfd49ed6381468dbd643bf08ae17079c956d5fa01582"
    sha256 cellar: :any_skip_relocation, ventura:       "0090cac6497803bdac79dedba2128f57213fe0f52b649fed722018d9c84fb964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471c75edc358c17801f6a7b35f4655a75d73a20438f63c86850a453f88bc8bb7"
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

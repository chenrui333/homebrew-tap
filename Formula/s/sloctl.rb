class Sloctl < Formula
  desc "CLI for Nobl9 to manage SLOs, Projects or Alert Policies"
  homepage "https://docs.nobl9.com/sloctl-user-guide/"
  url "https://github.com/nobl9/sloctl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "5ff18603d30843b792aac75447d145324483a8314048afdf1c64dc1777645c0c"
  license "MPL-2.0"
  head "https://github.com/nobl9/sloctl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39bf4083118c203b38704e46be54f0080156dce135da7dd2441438a9ce9939d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae1e71d254eaf3f45c70b253c14482198d684a64abdc5f3c700f6c9f849e1fdc"
    sha256 cellar: :any_skip_relocation, ventura:       "689fe9eb4e3d80e52d530988f815d520ecb79f20fb26b76eb261c439692a8035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5018724da2a4b8dc411159cd9f475e9868e0f078f2b92c0c6a24078176c49976"
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

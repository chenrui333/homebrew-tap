class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.133.tar.gz"
  sha256 "241d85344cfb872717448ca948cda8f57c93fc95dd241165b5476e6b58dd04d6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5c0d570c6802f6896513bb3683663ade237cd1e633dfb40e3e7a5b76348d9994"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "725bc035a65751c9136abc9c858a7d79a8527fba2885c355122816c022866eed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1207b3f1bd4c61e6b42fafec81798785335374bc17093af858a53ea50f0dfdbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "594baeb68421aa70b44d71e1ca68fe009431d780964e6fca0485500a0754d214"
    sha256 cellar: :any,                 x86_64_linux:  "e2316db504425f100a8a1243af90a771eeae9142a4c2f8d77237b3235a948645"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/RoninForge/budgetclaw/internal/version.version=#{version}
      -X github.com/RoninForge/budgetclaw/internal/version.commit=HEAD
      -X github.com/RoninForge/budgetclaw/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/budgetclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/budgetclaw version")
    assert_match "No activity tracked yet", shell_output("#{bin}/budgetclaw status")
  end
end

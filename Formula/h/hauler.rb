class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "03066f806b02f0565a1c99f2dfe98423824f48b285e0850dc3de4e4dc1aeccc5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e6d8af2d758421b01b19dd45c3f8413c38513d1d81abc855a3368f2212e3187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eb84e85c85f813bab9e90bc7386b2cc03e3b04b8af59a323867739b67bd908e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a023fa6fea083c8cdc4e75782b0c1c86ac681fde2a6ba1272bda72256268fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce74488c8060c60243844a744430368a2c450ca2ba6af83afbd874d45ac27f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafde82b8aeb106d7722e75ba520f926cc39dc910084c9daa1cd8533c4f070c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end

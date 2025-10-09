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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96753f4c2e14975bc58bedcc5e4dfb678a5ecc94f87f2df7bbd8f32f22ee4587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b650d9594fcb5ab2e8865c7dc84b5c96788248aadbd4cef152dd9586910e4061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fabd243f59586cefea37b64db22ad220c7cd9047ba793ef7213d1edcdc9e7bc"
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

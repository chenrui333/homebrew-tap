class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "03066f806b02f0565a1c99f2dfe98423824f48b285e0850dc3de4e4dc1aeccc5"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4f3fba7338c4ed469165801d54d88a8845c6da929d27f2d20805730942d5b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "193c1ee2e71cefd9d22620e9ff54e3385036c6d04e0de8d7990fb7ca98a38cc0"
    sha256 cellar: :any_skip_relocation, ventura:       "282c9cb998f3bb88a7146593c86ac01ee42242e87884f8c7619e28854725ac09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdeabbe2bb39e67a168c9a98a7a243f56ff323879581cc78d92414cdabfaf02"
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

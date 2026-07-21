class HardcoverTui < Formula
  desc "Terminal UI client for Hardcover.app"
  homepage "https://github.com/NotMugil/hardcover-tui"
  url "https://github.com/NotMugil/hardcover-tui/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "cfcccf491963e3dbc7edf84ce67a7bc90188ca7ef6387cbe725e12910becabfe"
  license "AGPL-3.0-only"
  head "https://github.com/NotMugil/hardcover-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e17f15b48c743f17d738f8fe07a08f20ecd5781523c21daececf831130660a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8e17f15b48c743f17d738f8fe07a08f20ecd5781523c21daececf831130660a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8e17f15b48c743f17d738f8fe07a08f20ecd5781523c21daececf831130660a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed292e51c883af22d15d2f79c198d548025bc558afdba902d0ae5cc44ce7bfde"
    sha256 cellar: :any,                 x86_64_linux:  "147d59994788166a2ae761c199bd52d0e1d3707f1396837a979db894dd5d165b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hardcover-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hardcover-tui --version")
    assert_match "Not authenticated", shell_output("#{bin}/hardcover-tui auth status")
  end
end

class Nhost < Formula
  desc "Developing locally with the Nhost CLI"
  homepage "https://docs.nhost.io/platform/cli/overview#cli-overview"
  url "https://github.com/nhost/cli/archive/refs/tags/v1.31.3.tar.gz"
  sha256 "adb9cf2e6d2fabc81687c97559f1ab62e7373947667b582f1dc5ff93bc972713"
  license "MIT"
  head "https://github.com/nhost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ce18990ee03de34f2000f6d320e67062304236905500b3eb993b78ce12137f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b27f51c2fffaf34c14dfaa2e78c55c3b0145ba5827e13708e2d96994b90bf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df63bddff0988ef8f6171346f1e07ce4d754e820f192b3e6e484439adaabaf48"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nhost --version")

    system bin/"nhost", "init"
    assert_path_exists testpath/"nhost/config.yaml"
    assert_match "[global]", (testpath/"nhost/nhost.toml").read
  end
end

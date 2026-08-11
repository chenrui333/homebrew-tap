class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.15.tar.gz"
  sha256 "7db692401db11d984996bf820d9bcf25a9a25b2d628f139e492d89aa7d139fe7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "009135717a360901fca4d6349b288784148ab17ba203d25a7c21624df794d203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd9ccf251c0e6ee98f15cd6466bb684900d96177b89b6a13c9133f172f7b2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f07b4bed7781267477968674374ee75150b2971c1fd285daf51c75082e120d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "296d69c2fbbe6f8257f700d0e00d723d9ebeb12658d7aef87ccee50cce9f44d9"
    sha256 cellar: :any,                 x86_64_linux:  "ad35ca41d96e022622b431f00bf8bfaceef75a67db14563b2124c21e49749651"
  end

  depends_on "go" => :build

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

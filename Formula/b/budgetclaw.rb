class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "9980490115895c789642452bd377faa9177dc9a38df0eee2a3d40fff2c609a01"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39b9c2a171668f0a5ab9d58c3ed3e6b084c82a33b815f6c7efbe81c92efc7018"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4606586531ed31fb0959b43a59f07a7131232b46a57058b1cc64081ccf21ac34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ab6658c1874672a13edfa9bab172f5adb11bf4a078924225957c10928d525a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5490c519ee7bfa689fc6ebd1e27e65b73888c961fe7a311dbfa35a6898aacdb3"
    sha256 cellar: :any,                 x86_64_linux:  "f7ec66a7401829f88bb1cd4b5264a363808c73b5a9cae80c37f091c303bc70a1"
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

class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b683c67a086d04c72a543bccb8258166792a91efb590bd7ba1503c77c1a9d369"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f221dd4977b8713d36ca2daf307d2fedfe52063aedf0606da1a866596ed189d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2de67f8e1001ee1a0910643a7aa16052d36327e6ae77699295dc4c000da34d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3349e8db06e7245c137320e159c600e53b7fa4821cc347cf6ff69c8121f0a7cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cddd15b4b2f561ee9498ef8bdfb2c36aacd6428a47b3027369a438a23647a7d6"
    sha256 cellar: :any,                 x86_64_linux:  "39d09a98f06d037ddfe6e51c7d56db999709dec5b2dc7b51b45477e926740588"
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

class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.7.67.tar.gz"
  sha256 "da194d61efb4f37e1dfd9453fc228e1fd2d289f3cc522e8a7178ac81d8484e9e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a48f8dbe5149775fb35d56abee7a56549b036666cb865c1680bb7701fbdf2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06c2720de4231a21722a085d546d2e914771d2241af9e37aced402caee55961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6617ee21bfdb7d330b7fd8eb16e52b41696bca3a033a8cde28ce2c24607aeff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a700765547b349a2cd585f18fdb4a0783d6c67d3098dfa8f5d1438bdc508f466"
    sha256 cellar: :any,                 x86_64_linux:  "a0b0839cdd09969458be7b27d46a301c41792bfd34036b5dc6f2a10956a52b0d"
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

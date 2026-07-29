class Budgetclaw < Formula
  desc "Local spend monitor for Claude Code"
  homepage "https://github.com/RoninForge/budgetclaw"
  url "https://github.com/RoninForge/budgetclaw/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "a207f7cee0f565dc67e301b7e8fbf7d1fd031937bb10c3535658293f70ecfe5c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce5f22ef9ee35d9b750a9b85d99cf935ad71ff25902ae70ae1720148dc3036af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95848f38fe00fda0519ba400b774a3212d51a804b87fd65493689277036b7b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af557f2b3cb3cb96b84d0125196a960e502d0e243326212c50d60f4302deaac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e52fca66fe8fd02268e7666d69c5bf3445aae5a46ddac605708bba648257df"
    sha256 cellar: :any,                 x86_64_linux:  "74948b4e1002d71808ccbb24d8dd40c6e8b9292dc6bb1953007f3eafa7802e96"
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

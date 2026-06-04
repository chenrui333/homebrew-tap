class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "1feda066c5646087f3a7981f6a13e7338b557c19cdf14ced9e65a057d6c9f37c"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "479ca0e177be39583b526d85bd364633d711d005b048c55a8c75b30c2ca0f65d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "479ca0e177be39583b526d85bd364633d711d005b048c55a8c75b30c2ca0f65d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "479ca0e177be39583b526d85bd364633d711d005b048c55a8c75b30c2ca0f65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd3286a0620b11d3df0deb661765098a1a2643f97366c6264b08e282f7c9b63a"
    sha256 cellar: :any,                 x86_64_linux:  "1476c433c245548c4677556a65a910e36c2abe1a10597bef85c2c70d3094b7ba"
  end

  depends_on "go" => :build

  def install
    cd "server" do
      ldflags = %W[
        -s -w
        -X main.version=#{version}
        -X main.commit=#{tap.user}
        -X main.date=#{time.iso8601}
      ]
      system "go", "build", *std_go_args(ldflags:), "./cmd/multica"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multica version")
  end
end

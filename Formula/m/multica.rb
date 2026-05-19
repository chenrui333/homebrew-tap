class Multica < Formula
  desc "Open-source managed agents platform for AI coding agents"
  homepage "https://github.com/multica-ai/multica"
  url "https://github.com/multica-ai/multica/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "f6f649ea46961252136980e4538eac14a050e86082cc8b70938d97d9e636161d"
  license :cannot_represent
  head "https://github.com/multica-ai/multica.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25b6e2b6dbe2ac3b886fc121bea3a5dd269327e0992ddf79b03c6fbd16dec2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25b6e2b6dbe2ac3b886fc121bea3a5dd269327e0992ddf79b03c6fbd16dec2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25b6e2b6dbe2ac3b886fc121bea3a5dd269327e0992ddf79b03c6fbd16dec2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70d709d7ce4f141d2cc07b888895aa709bb5a1a26ddfd3f1d2a3f49034e34790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97c156a0e96494aa86b7d6022a22785679cc23b62c4bfc1e76bf9692a972f8d0"
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

class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "5711bc0a19085fefa4e2e62ed169c283accdc4528151ad3c2366f2b2f24a99c7"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "579e3af0a283046cbec2d6db7cf2f92e3be21f0de019e49508ac28b4e9c16ebf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579e3af0a283046cbec2d6db7cf2f92e3be21f0de019e49508ac28b4e9c16ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "579e3af0a283046cbec2d6db7cf2f92e3be21f0de019e49508ac28b4e9c16ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca1d18136c362bcdbd9bb232348a9ea4dd1a304b3358866f2cb3da0703ec50de"
    sha256 cellar: :any,                 x86_64_linux:  "e6828bec843ca5c5e61be89f2f59274e13827fb41cc8a0bac296708792831d66"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gorae", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

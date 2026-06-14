class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "c91aa31bb27abb12abfec28f124bd778bd80bdb9ebb34cc23c563ac59d31416b"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac310bdc69deea55766eec665116f1c98058a9fd60ed58a7aa1a3bcdce811b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac310bdc69deea55766eec665116f1c98058a9fd60ed58a7aa1a3bcdce811b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac310bdc69deea55766eec665116f1c98058a9fd60ed58a7aa1a3bcdce811b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c82e72c2f5f4f9fe26c686b9c9f6f45382442a006bbca34d356d5d51f91fe0c"
    sha256 cellar: :any,                 x86_64_linux:  "a0740ed2ac012724635b3396a3c31fe136ef2bdd91ed1ed0911f33abca899ecf"
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

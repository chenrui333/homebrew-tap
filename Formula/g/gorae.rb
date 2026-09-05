class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "fd54081da0bb09981314af90dffefab2900c59eb39db0b1c49cadc09ac206f0e"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f311a7cade21e34008146154c937f3e626888e7277326b2d19c1e542d8c57e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f311a7cade21e34008146154c937f3e626888e7277326b2d19c1e542d8c57e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f311a7cade21e34008146154c937f3e626888e7277326b2d19c1e542d8c57e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78485cb25277c3e56e44d49c341db4a1b8a618f7478933f4da31f4925617a1d3"
    sha256 cellar: :any,                 x86_64_linux:  "529e71c5324c1605beab85881abbb7f75587817c3e9f33a4eb612b436afda04f"
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

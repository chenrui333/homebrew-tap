class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "3311745f83d6557405ecdb859f2823626bec416e92a0be0eeebabfb3944a8e03"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "987f18df3c2819973e58811b8782791248c084b1dcc97a81fc0e0153880884d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "987f18df3c2819973e58811b8782791248c084b1dcc97a81fc0e0153880884d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6459ae8eff1790cf4128a8eab8ebdf25bb84ad80ef56960a012450aa31c7e36b"
    sha256 cellar: :any,                 x86_64_linux:  "b9e9f89661e37026486c74b4b2467b01ac532d975fb342f83510ca657ffe4910"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gorae"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"gorae", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

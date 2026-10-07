class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "8881700d93cc7b2f811c2b89563b8c41b73cfe8513525f08271c7b1d3ec3af65"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "105d99b979e4ddb60e6e5c7a3fd3e4bb6af4c44106cb1240eb8513b030f9d940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105d99b979e4ddb60e6e5c7a3fd3e4bb6af4c44106cb1240eb8513b030f9d940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7698dd281b9969ebcb05a966409afe66460b3f25ed1bc8b71f353d6d43d5e07"
    sha256 cellar: :any,                 x86_64_linux:  "2885088ea2c99924bd04fd845a861e3f30f35504749af0e890ab572b6276ea54"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pho"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"pho", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

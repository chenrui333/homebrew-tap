class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "8881700d93cc7b2f811c2b89563b8c41b73cfe8513525f08271c7b1d3ec3af65"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bd89457182542c9672b5e3141b2c1b4e056179ece940a923efa32e2dc9f2ddd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bd89457182542c9672b5e3141b2c1b4e056179ece940a923efa32e2dc9f2ddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247e96650db011ace1d257adb9c6278b43de2c238ed0a93149e1652ae48ffdcc"
    sha256 cellar: :any,                 x86_64_linux:  "04158dfcd7ce414dbe01866e1a6de60ae1353ff0f4ba883f501c56b984ddd53a"
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

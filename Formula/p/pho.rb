class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9a3adf47c96123ed90c168264f313a6c03183df5648aefbdc9f433e8e1b74794"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33ee9777dba1c9ac112c86ed3f4d2c2822ee451ff0cafe3c1dbed61f7ee68fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f33ee9777dba1c9ac112c86ed3f4d2c2822ee451ff0cafe3c1dbed61f7ee68fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7695040441daba13dd2702aabcbc3970314589c9c5457d3761d657f6a21d2923"
    sha256 cellar: :any,                 x86_64_linux:  "46e57fbb6e2105c622b99032658df5ae859727a9d73a4e17e2d8d4ec06293fed"
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

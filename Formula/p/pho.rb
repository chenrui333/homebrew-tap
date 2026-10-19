class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "713c1bb3183aef4a96b4d8e97887c7b2b95c7b2baf6b5e98422841ec22a959bf"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9bcb820f0597d31a09509d113fe5000075e11afb4a377d61a94b179af7f2224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9bcb820f0597d31a09509d113fe5000075e11afb4a377d61a94b179af7f2224"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe5b10ff26da7ccf8dce551a482943fdadd86712252681de1479a1d661fc5b2"
    sha256 cellar: :any,                 x86_64_linux:  "4ea959c749905a6331b777aa4ed78bb6a4f98a825cd3edbe12de10d088d9e8d2"
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

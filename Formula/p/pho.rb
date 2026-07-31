class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.43.tar.gz"
  sha256 "889a0d573c2c5652993c98efce3165c3e2f9b55adea12929567691934e5c2449"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0360e653cc11250525db1845ff768051e036d5206634088d3d59c94b847910a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0360e653cc11250525db1845ff768051e036d5206634088d3d59c94b847910a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0360e653cc11250525db1845ff768051e036d5206634088d3d59c94b847910a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63da15691bde00fcc13247dab7fbd39b5a9469c4cc302a8709d3d6f8b43a1099"
    sha256 cellar: :any,                 x86_64_linux:  "a0915a604ddca7bd5caab52ef3ceab6bf3f14c29573ae71cdffe61dccd7b1e54"
  end

  depends_on "go" => :build

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

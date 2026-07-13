class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.42.tar.gz"
  sha256 "acccb2757afaedd2262c5beac611f7406e72db4825f8e0b5b54195c0de6bd6a9"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fe7a49322b58d3d3c4f5fe4cb04e152323f3f8d1159afc60df988b9650225e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fe7a49322b58d3d3c4f5fe4cb04e152323f3f8d1159afc60df988b9650225e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fe7a49322b58d3d3c4f5fe4cb04e152323f3f8d1159afc60df988b9650225e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168c7dad40f1c4cf217a153d3f149773621736b6014014d053fdf0dd3e36f075"
    sha256 cellar: :any,                 x86_64_linux:  "4faf505ee3b35ab055468490ccb82d19e3bb49cb743c2485e079578bc741eec1"
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

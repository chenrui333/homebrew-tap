class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "31348eacc7f328b4b62c5861ecd072b0a193ba8367e29a2b9eb4fdf5de0bb637"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c9cda3290816207a9912947d105579b82de4895d0f52a8fbc009878a334fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c9cda3290816207a9912947d105579b82de4895d0f52a8fbc009878a334fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c9cda3290816207a9912947d105579b82de4895d0f52a8fbc009878a334fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b26c787a11bea521bc81a672eb6d945700dc64fe5603261100027bf9be443f"
    sha256 cellar: :any,                 x86_64_linux:  "d21e877d1732b2e3b39ed8fc08a917bfdd42d9f7db050e1db9eb4ca32089fae5"
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

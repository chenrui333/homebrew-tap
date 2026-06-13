class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.38.tar.gz"
  sha256 "31348eacc7f328b4b62c5861ecd072b0a193ba8367e29a2b9eb4fdf5de0bb637"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a5665b25b45fddea230b7ce2b1a0f18b4124269357270fc982be9f5677128af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a5665b25b45fddea230b7ce2b1a0f18b4124269357270fc982be9f5677128af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a5665b25b45fddea230b7ce2b1a0f18b4124269357270fc982be9f5677128af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca62003a65cc5686a2dd49514ca06fe1ac0e1e936bb658b171be09bf7d397fc"
    sha256 cellar: :any,                 x86_64_linux:  "67fe098928bfd239780c4bfd77b464f7f2eb8a9f793334f7a24d0c9cc46862c5"
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

class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.46.tar.gz"
  sha256 "7ce2caa8033e188cb80def5c2a4fa5cef747eafdbf01bc3e279b419ae0d12bd5"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "508d1688b767e6f5eca07f4bd7e8a69856726b2e27bf686c75fce001cfec21ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "508d1688b767e6f5eca07f4bd7e8a69856726b2e27bf686c75fce001cfec21ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14757796f3310e57c8b998f27be4f82c5607d275eaec7a384036bac6c2a6ba55"
    sha256 cellar: :any,                 x86_64_linux:  "12b667f6b05c8b8427f78ed77f2a6c9ecca314651cef576c55ec418a0594bffa"
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

class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "ad5e09425de84b8ee3c4c64b3b4272c0816c59422e238b4d6263672f18174967"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9699a1645a48b3e0056f15da8f6dbc0a67c0d6fe5921337b97dd0f6bac67535f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1285d4495e96b28cbfe12b98acc28f74a544d33489d9f890ac93638dfc79727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1285d4495e96b28cbfe12b98acc28f74a544d33489d9f890ac93638dfc79727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd78b504f887163dc1134bdc27dce3b2e7b2ab94efe2f6602f18d47cda4e39e1"
    sha256 cellar: :any,                 x86_64_linux:  "ac73c0851090ccaca658ae70f9c0894b0654a813c4f9a6af36864c021eb863cc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/pho"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"pho", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

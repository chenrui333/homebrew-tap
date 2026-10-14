class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e959b23dad7b61ee1e8a1973630db1a8acb6c7cde45bcddeade982cd6c984d94"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10399d2cc8456b099335313708526a79d04a1810fab367ce48e9a2737fd0c85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f10399d2cc8456b099335313708526a79d04a1810fab367ce48e9a2737fd0c85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e579383d0b8ced73b7b706a3db6bebe0f3624715768982ce90aab49fd5432810"
    sha256 cellar: :any,                 x86_64_linux:  "83483ec9bb273eb0a11f30005f3b1e9514d597fcf44d1626726b96fff0de6502"
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

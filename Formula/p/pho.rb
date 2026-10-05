class Pho < Formula
  desc "TUI for GitHub Pull Requests"
  homepage "https://github.com/utkarsh261/pho"
  url "https://github.com/utkarsh261/pho/archive/refs/tags/v0.1.47.tar.gz"
  sha256 "5096bc201bc905062a783daa4dd9f4901b93ef1893d4169c9ae7443f9f16a6b1"
  license "GPL-3.0-only"
  head "https://github.com/utkarsh261/pho.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59ae49f917f34eca9ba67a481c62312ba96e1492e75ca44678133cfcad78bab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b59ae49f917f34eca9ba67a481c62312ba96e1492e75ca44678133cfcad78bab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea07041107287537ac302573ab78824d87c0c599f4506d345889f7adc9dafdb"
    sha256 cellar: :any,                 x86_64_linux:  "1fa07bd178ff7cd88a43735328bb0d23f788ef2bceb66a8f2748bd4d784f81d8"
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

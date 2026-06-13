class Dcv < Formula
  desc "TUI viewer for docker-compose"
  homepage "https://github.com/tokuhirom/dcv"
  url "https://github.com/tokuhirom/dcv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4e51cf466ebaa491cf61c36851364f4e68122bc281e3ecb65249c37fc8220fa7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af545d9ffe3a8a1303c40adaf2c384d1c65a9341164949f66814902310b2e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af545d9ffe3a8a1303c40adaf2c384d1c65a9341164949f66814902310b2e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af545d9ffe3a8a1303c40adaf2c384d1c65a9341164949f66814902310b2e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2daedc995779024078609f910e8664a9d50de3dfc1445f75c2098152c02d51a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121d3856f6e69e51114d53e6f2b5b29f48cbe9b63099c7af727fcf94ce6582af"
  end

  depends_on "go" => :build

  def install
    system "make", "build-helpers"

    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"dcv", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

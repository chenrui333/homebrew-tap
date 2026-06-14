class Dcv < Formula
  desc "TUI viewer for docker-compose"
  homepage "https://github.com/tokuhirom/dcv"
  url "https://github.com/tokuhirom/dcv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "4e51cf466ebaa491cf61c36851364f4e68122bc281e3ecb65249c37fc8220fa7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45e29d25f368e8e2d1ba66296b14a565c9c77ce5061163368abebe2ce11b914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f45e29d25f368e8e2d1ba66296b14a565c9c77ce5061163368abebe2ce11b914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f45e29d25f368e8e2d1ba66296b14a565c9c77ce5061163368abebe2ce11b914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb54b9090a60fe84bf92f0fc373af1530949e06beb972a5b620be5539ac31fa0"
    sha256 cellar: :any,                 x86_64_linux:  "43dbd179d68a7866f9dd2f352346d947a3f3d7e535a439e7c05280c91725d506"
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

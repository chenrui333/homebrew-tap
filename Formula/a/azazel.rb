class Azazel < Formula
  desc "Runtime security tracer using eBPF for malware analysis sandboxes"
  homepage "https://github.com/beelzebub-labs/azazel"
  # no upstream releases; version based on latest commit date
  url "https://github.com/beelzebub-labs/azazel/archive/a00280a94ac99f257c6f95d0b324ab019bc7d993.tar.gz"
  version "0.0.1"
  sha256 "4e56509bdb00f34dd5b628428cc88ebc999d8ca35452daa6c369ee5a9631477b"
  license "GPL-2.0-only"
  head "https://github.com/beelzebub-labs/azazel.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3618fa6aab8c9229579a14e3e4ce0cdbab9dbcab421ea27d2f4254b1d67215f6"
    sha256 cellar: :any,                 x86_64_linux: "a3ed120cad58cf22ead005fbe858479cbcc9b953c433ca6022acfbc53664d14a"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"azazel", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end

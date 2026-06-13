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
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ef4a67163637ddee7a95224eeb7afca554bca07fbc00b2316512882c926b8b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b94dfa7cc638338ce9093f13ac3116893d56beafe3413d57be81fe092f92ae35"
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

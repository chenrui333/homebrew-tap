class Azazel < Formula
  desc "Runtime security tracer using eBPF for malware analysis sandboxes"
  homepage "https://github.com/beelzebub-labs/azazel"
  # no upstream releases; version based on latest commit date
  url "https://github.com/beelzebub-labs/azazel/archive/a00280a94ac99f257c6f95d0b324ab019bc7d993.tar.gz"
  version "0.0.1"
  sha256 "4e56509bdb00f34dd5b628428cc88ebc999d8ca35452daa6c369ee5a9631477b"
  license "GPL-2.0-only"
  head "https://github.com/beelzebub-labs/azazel.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "azazel", shell_output("#{bin}/azazel --help 2>&1").downcase
  end
end

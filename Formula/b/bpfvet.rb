class Bpfvet < Formula
  desc "BPF portability analyzer for compiled eBPF object files"
  homepage "https://github.com/boratanrikulu/bpfvet"
  url "https://github.com/boratanrikulu/bpfvet/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e897c6d1ee9e942b2023443a7769a8e0a4ec3754ed2756055a0b3c40fcda3531"
  license "MIT"
  head "https://github.com/boratanrikulu/bpfvet.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bpfvet"
  end

  test do
    output = shell_output("#{bin}/bpfvet 2>&1", 1)
    assert_match "requires at least 1 arg", output
  end
end

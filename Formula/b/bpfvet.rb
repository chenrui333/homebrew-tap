class Bpfvet < Formula
  desc "BPF portability analyzer for compiled eBPF object files"
  homepage "https://github.com/boratanrikulu/bpfvet"
  url "https://github.com/boratanrikulu/bpfvet/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e897c6d1ee9e942b2023443a7769a8e0a4ec3754ed2756055a0b3c40fcda3531"
  license "MIT"
  head "https://github.com/boratanrikulu/bpfvet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e8332b42a4b79b3e8384d56699884d6b3b828eaa250013db084baee62c1a9d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8332b42a4b79b3e8384d56699884d6b3b828eaa250013db084baee62c1a9d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8332b42a4b79b3e8384d56699884d6b3b828eaa250013db084baee62c1a9d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e6c5a49ee5a96a5316f0ed61357d85a300e0b4a33f2663cf65665c7b689cddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8227b02de01c743e5871f434e8c77555aa185200030e637da93445c375b88702"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bpfvet"
  end

  test do
    output = shell_output("#{bin}/bpfvet 2>&1", 1)
    assert_match "requires at least 1 arg", output
  end
end

class Ghostscope < Formula
  desc "DWARF-aware eBPF tracer for source-level userspace tracing"
  homepage "https://github.com/swananan/ghostscope"
  url "https://github.com/swananan/ghostscope/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "44bb1758df1bc354cc69dcbebcbda4f29d46c72e14e489447dac785b2cdabd26"
  license "GPL-3.0-only"
  head "https://github.com/swananan/ghostscope.git", branch: "main"

  depends_on "rust" => :build
  depends_on :linux
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ghostscope --help 2>&1")
    assert_match "ghostscope", output.downcase
  end
end

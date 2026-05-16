class Bpftui < Formula
  desc "Interactive TUI for browsing BPF programs and maps"
  homepage "https://github.com/viveksb007/bpftui"
  url "https://github.com/viveksb007/bpftui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7bceb2c4fae5a3da5f282ac8338b3873df2ffbd846abc8d49d82e5f6cb96bf2c"
  license "MIT"
  head "https://github.com/viveksb007/bpftui.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/bpftui 2>&1", 1)
    assert_match(/bpftui|tty/, output.downcase)
  end
end

class Cashd < Formula
  desc "TUI for personal finance management"
  homepage "https://github.com/hzqtc/cashd"
  url "https://github.com/hzqtc/cashd/archive/refs/tags/0.1.5.tar.gz"
  sha256 "c996be017f6598540d5bf8cd3dfbb4d73d0398bf5e941148018d426cbce7df4d"
  license "MIT"
  head "https://github.com/hzqtc/cashd.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cashd --version")
  end
end

class Gitmux < Formula
  desc "Git in your tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "c62b180415c272743d01531b911091b9c35911be4ec4aae3e7bfceddf5094f6c"
  license "MIT"
  head "https://github.com/arl/gitmux.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "gitmux #{version}", shell_output("#{bin}/gitmux --help")

    assert_match "tmux", shell_output("#{bin}/gitmux -printcfg")
  end
end

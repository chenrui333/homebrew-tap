class HackernewsTui < Formula
  desc "TUI to browse Hacker News"
  homepage "https://github.com/aome510/hackernews-TUI"
  url "https://github.com/aome510/hackernews-TUI/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "2cb719204d92e4e2f8f86f7e666059ed0e884ee0c12fc58393bb967740a9c3f3"
  license "MIT"
  head "https://github.com/aome510/hackernews-TUI.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hackernews_tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hackernews_tui --version")
  end
end

class WikiTui < Formula
  desc "TUI for Wikipedia"
  homepage "https://github.com/Builditluc/wiki-tui"
  url "https://github.com/Builditluc/wiki-tui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4f51547c0597ee9d6be9e946a612bfc052f8addd59b01f2bd599b31c3b636004"
  license "MIT"
  head "https://github.com/Builditluc/wiki-tui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki-tui --version")

    output_log = testpath/"wiki-tui"
    pid = spawn bin/"wiki-tui", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Search Wikipedia", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

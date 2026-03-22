class WikiTui < Formula
  desc "TUI for Wikipedia"
  homepage "https://github.com/Builditluc/wiki-tui"
  url "https://github.com/Builditluc/wiki-tui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4f51547c0597ee9d6be9e946a612bfc052f8addd59b01f2bd599b31c3b636004"
  license "MIT"
  head "https://github.com/Builditluc/wiki-tui.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki-tui --version")

    output_log = testpath/"wiki-tui.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"wiki-tui", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"wiki-tui", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid)
    Process.wait(pid)
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    refute_match "No such device or address", output
  end
end

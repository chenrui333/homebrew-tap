class BitchatTui < Formula
  desc "TUI client for bitchat"
  homepage "https://github.com/vaibhav-mattoo/bitchat-tui"
  url "https://github.com/vaibhav-mattoo/bitchat-tui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "626860df233f337ab204de3d64b04fc03aaeccbf9e8d692d53445d24cf5d6bcd"
  license "MIT"
  head "https://github.com/vaibhav-mattoo/bitchat-tui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"bitchat-tui", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Public Chat", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

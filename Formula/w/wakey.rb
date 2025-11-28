class Wakey < Formula
  desc "TUI built for managing and waking your devices using Wake-on-LAN"
  homepage "https://github.com/jonathanruiz/wakey"
  url "https://github.com/jonathanruiz/wakey/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "29a58792be3334063bf8b2f5b48f9193a5d308b41a7e7f3b2a704d0bb05aa53d"
  license "MIT"
  head "https://github.com/jonathanruiz/wakey.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"wakey", [:out, :err] => output_log.to_s
    sleep 1
    assert_match '"devices": []', (testpath/".wakey_config.json").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

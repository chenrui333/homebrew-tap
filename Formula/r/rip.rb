class Rip < Formula
  desc "Fuzzy find and kill processes from the terminal"
  homepage "https://github.com/cesarferreira/rip"
  url "https://github.com/cesarferreira/rip/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c0e57126bb07a11352bccf30e067b35cb9a3928d458789f77157ca2ae038603b"
  license "MIT"
  head "https://github.com/cesarferreira/rip.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rip --version")

    port = free_port
    ruby = RbConfig.ruby
    pid = spawn(
      ruby, "-e",
      "require 'socket'; server = TCPServer.new('127.0.0.1', #{port}); sleep 60"
    )
    sleep 2

    output = shell_output("#{bin}/rip --port #{port} --confirm-nuke")
    assert_match "Killed", output

    Process.wait(pid)
    assert_predicate $CHILD_STATUS, :signaled?
  end
end

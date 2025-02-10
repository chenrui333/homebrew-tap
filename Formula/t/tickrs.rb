# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "95069ca7285859e015762e46acea2161d35b8e53932446ff5a5f4556c2950729"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tickrs --version")

    require "pty"

    output = ""

    PTY.spawn("#{bin}/tickrs") do |reader, _writer, pid|
      sleep 1
      Process.kill "TERM", pid
      begin
        output = reader.read
        assert_match("Add\e[22;7HTicker", output)
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
  end
end

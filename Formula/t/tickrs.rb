# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.14.11.tar.gz"
  sha256 "e6c7c4cfbc381c4e56316734335c87e88f32b722afb91ea1bd96bba80297660b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f374eacc0c920e4ac84ce21b409c6d3f31e96441eceb43ad5186431d55ff3f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41e6f649430deceaaa7f0a844661ae863fb0ca78bda33120c72732f7ec48a06"
    sha256 cellar: :any_skip_relocation, ventura:       "8da8946689863ccbf0b609f03f1e325e024973d73fd46aac377c2732b9f2ffb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4b8a0047b7d9e0e9ec1c8b77ee3546031dbf996b8611f5f874be17f61acb66"
  end

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

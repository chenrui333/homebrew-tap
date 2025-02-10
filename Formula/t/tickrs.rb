# framework: tui-rs
class Tickrs < Formula
  desc "Realtime ticker data in your terminal"
  homepage "https://github.com/tarkah/tickrs"
  url "https://github.com/tarkah/tickrs/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "95069ca7285859e015762e46acea2161d35b8e53932446ff5a5f4556c2950729"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1644d925bb209e5d15dff6fd3dc2b870b6acdac96a45f7f4e183e366997bb8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9904ae2470b0aaf3dcc43a7e4dedfa3ef0cd034c093886527e8fe6a95e1f510"
    sha256 cellar: :any_skip_relocation, ventura:       "ab6730b2fa0cef032c06c20c48c984c11ded1edd4c08359f0de5791ca4d6ad8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f482f50acafb54b7b0a84bee8d83df3dab4097b2e16c761a5559f9d82e0a3d8e"
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

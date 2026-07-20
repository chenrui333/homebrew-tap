class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.7.0.tar.gz"
  sha256 "fb7e254a55b7053473f498bc68fb42ef250984a92ae0790ad8cda282817fa2b6"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "099e09b3d2d418106fd1c4e94d1edc0cc8cf25a165601a085c6fad1d44fadebe"
    sha256               arm64_sequoia: "d025ffe5968b2d96000c77ec482b07ac06b80ef6289dbb211d556e5dee25ddb6"
    sha256               arm64_sonoma:  "53beae42768cd172c2de09612599a10bacaaaa3c692e3c24219326b1d4a214eb"
    sha256 cellar: :any, arm64_linux:   "24dc8efce88b976929df07bce746338d181b6737cd1357c64a5d9c19ecf2b4b3"
    sha256 cellar: :any, x86_64_linux:  "09482922a26f9dcb6f8597e33d7beb5c23e6e969ca342f912cc175be61c1d50e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "sqlite"

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "timeout"

    assert_match version.to_s, shell_output("#{bin}/eilmeldung --version")

    output = +""
    PTY.spawn({ "HOME" => testpath.to_s, "TERM" => "xterm-256color", "XDG_CONFIG_HOME" => testpath.to_s },
              (bin/"eilmeldung").to_s) do |r, w, _pid|
      Timeout.timeout(15) do
        loop do
          output << r.readpartial(1024)
          next if output.exclude?("Welcome") || output.exclude?("Provider")

          w.write("\u0003")
          break
        end

        loop { output << r.readpartial(1024) }
      rescue EOFError, Errno::EIO
        nil
      end
    end

    assert_match "Welcome", output
    assert_match "Provider", output
  end
end

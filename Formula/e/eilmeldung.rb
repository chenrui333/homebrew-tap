class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.2.4.tar.gz"
  sha256 "aa9d0ec29ee5b699096ac984251185c545329b6269093c64d07780898766e232"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "614aa11d56edbfa7e88ea427df4cc022fc620a044ec0d368c96ab735d01959a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caebe10de6a44d74064991e457d25fd61c8982fbdfa4cda51bc2ef005c5607d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b853862607d3b732f0dcae79dfc867768db324e0d3bc2b0f070c9727a9d6d7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99434e3e6d7fcf0b92349314c8d591bf22c1522f3fe0e9f6dd251e812e52ca5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66463b1d8c4c8bce468ad127e7cfde21acfac5ca6122ba4f3091e9a68e94ab81"
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

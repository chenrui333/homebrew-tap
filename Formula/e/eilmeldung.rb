class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.3.1.tar.gz"
  sha256 "1034b434b52abb0abf5dfc13bdfcf5ca1177d200cd12f4260c90f08f269803cc"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e33c5b18be22f8f3206d11cba38b30ae2f17eeb7794ac15c730c3d48e8ba9811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7f7329d575d910b1236896b9ad4f21e833973fdee19a2bea79697b4c9c98826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4edbfa6b239b1b7b80edc0d9c1920f8ddc54e7974593d1456982b19ae8bd4604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67e763238659d5f41129bc9dda7f122e23ae8c65e367973727ec76adbb0834ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f8b791ffbcc34d83f52a4d3e0f70de5505251a48e2c0f0cce143b58c7f9364"
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

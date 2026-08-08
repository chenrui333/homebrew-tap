class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.7.2.tar.gz"
  sha256 "26fa6822891e69248fe25467091329b7fe63f39073dcabd5f903b457ccc7e28e"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "d2282997a6db5805ee8dbfc1daa78893317366e0fc0bcabfd4b4570939ef81cf"
    sha256               arm64_sequoia: "fb80169aaf79beb55aa464e04ef8253aa49b1ca144f829eb7e6901fe8e0ca1be"
    sha256               arm64_sonoma:  "4c9ba8ecf13b17153f6e41b5d8f46f3cc08f3a6169c35cf10de066759dfaad88"
    sha256 cellar: :any, arm64_linux:   "18721f289ec658f932a43acee45313fc71a3e121c7e789c75e4ac2598aaae597"
    sha256 cellar: :any, x86_64_linux:  "9453fa952e09c26210deb9059b785f51d0577728ad9c1f72a613cb1fc9c410cb"
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

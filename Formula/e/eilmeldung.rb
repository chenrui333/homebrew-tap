class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.5.4.tar.gz"
  sha256 "aabb59f3be671d679f5b27bd98545f13004cc5524fad6a3f9a0f6c6c3af52195"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "d1b669b2dcfb93cdf7025512bbe973f89a1aaf8502ac128342a810e7d7843fee"
    sha256               arm64_sequoia: "309908386767715c8cf67c29af1b06dc9853745920c9bd5273d55f3edd662856"
    sha256               arm64_sonoma:  "a2debe624aa11c5e2bef2b70c35f67e126169ee942bf6673e8f0813437b4d0a3"
    sha256 cellar: :any, arm64_linux:   "92eb4dff3b70da5dada3ce8fca2d0d35f4d4fbad61f9370c4cc8b10678ab8769"
    sha256 cellar: :any, x86_64_linux:  "7004e90708223d6e52a6263fb994228135153e49fc4b06dee4d76679857c04d1"
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

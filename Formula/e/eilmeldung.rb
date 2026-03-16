class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.2.3.tar.gz"
  sha256 "2890af8656acf7996b0c312be7063495d4ddfcdc997e63e218df73401eddae55"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a670e189f1652bc7a1d022d071f6e9cd0631be1607d778bc54109fe09b4aa21a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff8af5bfb58afb46ba7afda9d7fd0dcab75efcf114d9a3be7ea5e400a68407e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80fefd5b9ac87e2b9d3721cacb71fc888e65eef72baae0bacc2135d70eac1b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3168b67f1720f10108d8aaa7e0ff9b7a44051d0acc5de87ba95434fd2dfc764a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5846c65002e97112c61080ab1015d6ef087abc613b1f1518ab91ca5fb55a0b6e"
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

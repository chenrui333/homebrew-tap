class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.5.3.tar.gz"
  sha256 "8401280c214f06fd03b613f16d5603293d065500a39976ddac6105d93b509da7"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "032cb2607917f0d8a2af1ba3b30c10ba33d90862f17a66eac9b6cf582e9916d6"
    sha256                               arm64_sequoia: "e33521684c70d9bc2d42443e7102be445c4fb6cdcac4a840458c2c0e589abb6d"
    sha256                               arm64_sonoma:  "5c0361c28bb325d8da9719ab1cce3d259d06a82a9cf354b539558abe76649098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d2afaae1a360996b47c252990120dbb60093a4aebb24d915174ff44bf5d54f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "734e8c2242587bebbeeaa179daca4640cd6cfd7a12fdd19180ba6e755611e638"
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

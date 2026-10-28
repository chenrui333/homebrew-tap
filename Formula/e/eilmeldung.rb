class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.10.0.tar.gz"
  sha256 "3e4f875eef140f223a107a995aff3a225692dc4bcaa26e0c7f9171cc48ca2a46"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e1836f96db118564a43a0a7ad5b775e5bce13df4f885dfc6d83e2059860a8f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c53dc0dd89ca597946eacb89c775b95372f2750b8b298eda573c85acfaf535"
    sha256 cellar: :any,                 arm64_linux:   "344eb1a30b49fabbf32a27134258b53a5f39c8f36ebf14523199dd7a8048ca9a"
    sha256 cellar: :any,                 x86_64_linux:  "d4779498977ab770569a0a50c9a7edaa4e9bf24c9f9b8ba8e917d6f8f46dbd03"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "sqlite"

  on_linux do
    depends_on "llvm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

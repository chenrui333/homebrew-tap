class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.4.1.tar.gz"
  sha256 "3e4cdb03f1a1ea1ddcb336aa937b16bf2dbdcc66ad32e500124ee7df1c319eb6"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e89f03f7317c9cd8c3f02dbc440127c0f19bb6b3158d40a0b0285b53836cce6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840a2483db0e527bbe3c2ee96858eb0da6f1fe68a950c20732fb601054a8b586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bafc479746fb6144d40ce56015ed51107a971f5ccf210941bd5e3a271c00eceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dbe8a318a364c455ec3447732fed93ba8a157801afa09c93c7b9514b1015253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb810d0b263bb8460eaa41765a657d9a299d01f94038ce3057a6b23640dcbe2"
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

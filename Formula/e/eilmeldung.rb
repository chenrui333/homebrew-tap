class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.5.4.tar.gz"
  sha256 "aabb59f3be671d679f5b27bd98545f13004cc5524fad6a3f9a0f6c6c3af52195"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "87dc9a5b0648aeeb502fd19763c00a30381b04d13c071f11417ad346657321f9"
    sha256                               arm64_sequoia: "fad1b895bdbb164d177d47496692f905d79879e7a4df8c888891093e64bd67dc"
    sha256                               arm64_sonoma:  "f2c6f9c80c93cba456587f1a0390f836a058553849f8860aa5161197a40731af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcebf0ed6502284106f9d529c399bc8a69cfaf994b810665e9a5d017cd83a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5648faf0be02ae39972393eaad77365d677cc38db150d509e5a9b416fe854e"
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

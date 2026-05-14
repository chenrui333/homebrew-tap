class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.5.2.tar.gz"
  sha256 "7109d35bfcb16d7041d40b9d81a6e60f0bf7f9f478e56385c29fe22ce701a8ac"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "5e5a271085ffcc11ee29ef010fb7517396c282ce6208914cb5b3b96320680cbd"
    sha256                               arm64_sequoia: "48d359b063920c5be80bebb468d71b1e5cc6153d00ffde76fbc33738c06c8d03"
    sha256                               arm64_sonoma:  "49c1c74ba407e0afeeb09a116772ae54d7b20779572e1783dd508d6f37de83fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3bf76a24d68e973554dd7172b5cb9a2123ce08c6850ede28b3028e6d1f2fb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d771ec72637c9875082d0278a32108afe17d1567b970fb659f7598e9f6c3fa0"
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

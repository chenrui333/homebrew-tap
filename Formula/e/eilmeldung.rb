class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.7.0.tar.gz"
  sha256 "fb7e254a55b7053473f498bc68fb42ef250984a92ae0790ad8cda282817fa2b6"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "b9287f13df3aef8b2e3c806f6f54e5569454fa8269c958afa01a46b4c0f9209f"
    sha256               arm64_sequoia: "90e0756ab5a7c4b87eb3426f91eda45cc810a543d26f9195a51e602f695e76d3"
    sha256               arm64_sonoma:  "6aaae4178aebeedb201a38ba1d9783c0fcf57ad5c20d403c00740b0a5493c57d"
    sha256 cellar: :any, arm64_linux:   "f012c84c69cc5ffa585e480312273f1dc9e84211b2182fc32944a6978b31e032"
    sha256 cellar: :any, x86_64_linux:  "f8f62332a7419ff972773dff14ae953e69513ab287bdaaa5c46ea4da3f40498f"
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

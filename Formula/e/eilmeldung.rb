class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.3.1.tar.gz"
  sha256 "1034b434b52abb0abf5dfc13bdfcf5ca1177d200cd12f4260c90f08f269803cc"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a209ea7aab998ad912a6e09f9f119b0af7e1bc5af9363523522b973b40895176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a3001df872a0b2d7214b704fdad40840d2502964d7eaef95d522a9b7acce58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603fde62f2024bf0742adc1e2fc87c21940cd61d0b7c033b0cf09dea085b2206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922537d37c0455bec2b1814be0df60bc9b98445413369c9c2128750af4c205b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6679a7c0f7b957397fda221a85fc5d9ef2a0ed47aef5a0efac334289d4ff1e54"
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

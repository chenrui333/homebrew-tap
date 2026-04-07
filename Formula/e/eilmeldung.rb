class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.4.1.tar.gz"
  sha256 "3e4cdb03f1a1ea1ddcb336aa937b16bf2dbdcc66ad32e500124ee7df1c319eb6"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257588ba766368b62dff6bfcea92b51e3f8580a41744818846ec3ffac3f0b7d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3066b5c4f2a49211030338db471b6cd08cb710f92bde5ff069c403d3beb88de3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "049665a983e77639ab5059aea08c6986068d2cc83671ed832a3418d9beaada5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140551d4b1340b61e1477955c9920eac3517b327bcc38cccc9609a6867058d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0061f1cec59f2f9fcfa9fb4463b35fbfb5bee67b10692701ce3368063c1b25f1"
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

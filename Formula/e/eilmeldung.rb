class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.4.3.tar.gz"
  sha256 "0f7f007388a37cfef8a02d82e4569848e466a840526fd729a51d3fae3b7c1a4f"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5dc07aa8faaed3c93240e770318a1c2ea26e50ef49c0096fb94e25b609d7d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a69898080ffcbcc3aac2c5692cdda7a230c522ac1af26817768486edae5ca2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7b90e408b57e85519154bcbfb11a3ac6d650008c13a1277725d5d1fb0ac997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53d2f86cf6ee4aac7881227fc239b898a55d46ad3e6e086e3b397947d9f489e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7694ff1a781ef377b038f8506eea3a3e24822eced19e580cb1a05d082192a57d"
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

class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.9.0.tar.gz"
  sha256 "efcc1fb7a3a0596d2897af84680ba50a55e2d1c8a550dc6383891ec333d39326"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dc0f41658643bfba81dd0b0da705f564fab781c51d2b0015bfa4488fa16c0e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "560dbb1e7f54f5379467d61365df68ca314abba9d45991299805b1cb4a722ed7"
    sha256 cellar: :any,                 arm64_linux:   "5703d3f65ee632e8e41effcbf9e93901e1bc9fd6d47f6d0d66ea13dcea680a68"
    sha256 cellar: :any,                 x86_64_linux:  "c3820b75ef2ad9383a3a514af1fcdf90292de225fdfd1edf869108bac53d89b7"
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

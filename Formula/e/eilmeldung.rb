class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.1.0.tar.gz"
  sha256 "566aa7ec5477cd66ecf88a30f3faaeb84f873628dd11e5724f54a89677298b3c"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb87a8b7327ec0da79c00ed3b50114aa0e4a3867885c57bd80b025404732c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898079ce5035e68a9d0e97f1b278a2dc75c25490b548435e481d0988c660c5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea4575eef89c7022c241c22c78b998375c4f6c475fa044d4d8a1a0096c90559"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7512447492d219b8a096a785bfb5707c693747ba2ddd425cf6bf196374a058a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "841f445a2996a5696a8d52003d7489b43d9d58bc97ec1e9a8aa43c658d328a33"
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

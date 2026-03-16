class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.2.3.tar.gz"
  sha256 "2890af8656acf7996b0c312be7063495d4ddfcdc997e63e218df73401eddae55"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81233e832420da383d2e25a9df19cd829abbfa2aaac46cf4ca10f150d49b2f9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e9498b1e605acfec2c18795b5f4be8f2d79a14b9261cabc299311daa1255b04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f46baab1ceb3bad84ba9f923fc0483c7596f5365ce1fc14fb2b47f8c4116de5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ee0be62d20886fc1ee6fa34f207c951d1490ba1137eddbcc334fd50642ed23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e139241f0714656b73cab87a58068ce80f7824514eb12acbd45fbc7b8edab5"
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

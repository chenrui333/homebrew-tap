class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.7.3.tar.gz"
  sha256 "530565b8b3f86e79368476fb6affd0bca813e67d0e86fbf0133e1cff10e808bc"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7388b4d207fca7b86f2ef64621d94b7a81d555ae5bf3c18c2b0e407fdff6a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7476fbcd4e0a3cceb8221dcf94741fb1b17b79be5e3d7469698c19505d819e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b609cf4fbb14c88d82568406d1906700b7a9965613e9f378bedf8725af320ecf"
    sha256 cellar: :any,                 arm64_linux:   "1469560a64e870bba3dfd5a8ea3f3e9c15ee2d86680ab06b3c1ec22eb76fb63c"
    sha256 cellar: :any,                 x86_64_linux:  "cf778a05ae9822756941aa945e90c27a34605a4047a4cb7ea38bef6b9a700be2"
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

class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.7.1.tar.gz"
  sha256 "b4d19c0d4eb3e3f44a04e4cb0e54f714f391f7a2bd85ea9a5284b04108e9a134"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "00f1891e97e281259d0e124a4d8e7a9bfad014a08c8fbfea30884d0c0acd6fe5"
    sha256               arm64_sequoia: "fcac3cc47811bc7b0e2dcd2667d9245393dda5abb9af0b3875f1597fbe7c7a23"
    sha256               arm64_sonoma:  "dfe3c93923acd07ee30eb8e97bfbfbb22ca60bf6b439f55e3e89f5a835b2cc8d"
    sha256 cellar: :any, arm64_linux:   "567cfe64c5ae705dffc2c84c5a80b45f297861c4d97000505f299328ee88e8a5"
    sha256 cellar: :any, x86_64_linux:  "446941fdbc4dc1c4bf5aeba83b2b10554140d5081f1a068ce116471ca0ea1222"
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

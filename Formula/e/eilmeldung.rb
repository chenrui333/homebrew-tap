class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.4.4.tar.gz"
  sha256 "63cee4e949518b32f3f30d4c12909ba256715d77308eca8691343a51d24da67c"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "061cca4865f6efd679dc6ba7d27a9345c09ab02e596c00653c14d06e2e9adc3b"
    sha256                               arm64_sequoia: "04c68c3cb53c4da989bdbdfbaf1858542bafb983ba97c3ac082939c9da340a2c"
    sha256                               arm64_sonoma:  "0092acdc0d48d3021bc1a1d8ad76e1f6fee377238d4ba44988291288a7ab830c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efe85964ff484acfc8cf7ddecca83c9a975c55a7e6680ec04a466a29f4aa4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9336b473516b8cda82b396d9b3abf8739da475ef348e1ef410600187ff7c955"
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

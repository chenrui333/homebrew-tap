class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.4.4.tar.gz"
  sha256 "63cee4e949518b32f3f30d4c12909ba256715d77308eca8691343a51d24da67c"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f76fc67992085532236a968e30558de8444c2f146a720649ea665d79a8c7d7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b610a6d4681454c919fd3a561dfb3477c4a39045cd71b51f4797f88f6663811a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b5b21a542b5a9fa2376bcea40c312b60713fb7d505da0152c2acb051330449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac24de4a8854ac42b4f11eaef7723467f261b4a03ac741ee5d6de5630b245b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0ee9b8ebfb7239889350323ac254002ea5569f1d30a654411db1e89e3d48b3"
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

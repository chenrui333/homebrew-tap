class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.1.0.tar.gz"
  sha256 "566aa7ec5477cd66ecf88a30f3faaeb84f873628dd11e5724f54a89677298b3c"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba46fb402575232a75e2de3cdac920c995232afefe4ab57cfddca0579850ba8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ddf8abca45730a0c5bf701ccc6bc7416d2db827403278497c48da72765145a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4eb6b7269b89db0433f4c3d9f215faaa8eee07dfe6f4828375e2bc49ca61a99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1840a7156d0648cfe9e48f7c1f4d8cc6654e4b84f747a7721d4da4690eb67e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56041ad2099009113c5a462511a5ba1db9a860ea0ced7fffb8949453f2bdb71"
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

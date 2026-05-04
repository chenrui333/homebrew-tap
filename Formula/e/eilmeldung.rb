class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.5.0.tar.gz"
  sha256 "37198bbe7cef1e061211e35f48df2d0cfda1139ad3e90da041c885e77fab2877"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "2d601d172c9a49fff552669bb18665f0346fc233e4f7cb5d1611bcda187518b4"
    sha256                               arm64_sequoia: "b324d98de57875903ac3707b922a65f6bee8154f3002374bda28c01917a245bd"
    sha256                               arm64_sonoma:  "a754b42870bb24066a31713f7159ff83c4aae2dd7acbcb61d0108128246dc6f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a34e3c9bf0adfad6c6ec2832f984885fe620e0b4b5eadbe75d174dd6e79d5a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3285e3f017775673c2abf47503e92718949452b170d269e508217805ffa2cc94"
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

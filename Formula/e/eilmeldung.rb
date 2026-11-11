class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.10.1.tar.gz"
  sha256 "aa62a74eabb7f8cecf38faac1485ea6a712dc4b618d97c92ef8571703d74f0ee"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c08947c30dacd260e7446cfa0dd4de241f9f124a96409120047c81909c98215a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bf6365e0143f586596a623c14003d8fc43674ed3444f18ede73038d38194704"
    sha256 cellar: :any,                 arm64_linux:   "0d2d4a164996f3aa842542b876db86166986df2535645723496dd8c787365fe9"
    sha256 cellar: :any,                 x86_64_linux:  "81a7e34994fb35fcf07001aeaa85fa03c9dfcade5aba2fe4e30a40d06d009071"
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

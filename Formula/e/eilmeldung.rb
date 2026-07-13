class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.6.1.tar.gz"
  sha256 "2988745bf0c1e35d1dd5a750306fc38be9d36fe55adb406bfbce8e976f6e5b74"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "2f1627b50a76833a66b3aa9c60b036db4ca552076996492c0c43d18d0f5dbe63"
    sha256               arm64_sequoia: "ebb86f63c6465ffa63748b8757d02bce69f8ef7191256bae5ec97d78d43debd8"
    sha256               arm64_sonoma:  "f4054c6e07baf90678c583e3e1118378d394286dc02610a1fe5f572826d2fc75"
    sha256 cellar: :any, arm64_linux:   "e4fb415eff200f5876efe630c238e2f9c92af61d30038a6d37e4aee31614a70c"
    sha256 cellar: :any, x86_64_linux:  "8946739a4f2389cdda7c012771e0fde9b3dd25eb41a00c2dd9c0bf2bd11bd30c"
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

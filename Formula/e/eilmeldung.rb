class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.8.1.tar.gz"
  sha256 "c1d1a6248ed1f5a2e1b924f2db1653d1a045de69af4ebbd0ebf1a58b0d3a8e9a"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "746720122a3cd127699d50bf2d70176748eb46e00db703a85d29375d2668b5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04cb9d556981da14cbb0961789633372d355361c4a00dc307414410d0baa9aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e6aa837e2321c75d69179e24a8ceedb532efb601f8cf8c2885d4155e8a05fc"
    sha256 cellar: :any,                 arm64_linux:   "9f8470a2431a1f8e62346577bd1babb444689f090dc919a2a927b01e2d095b75"
    sha256 cellar: :any,                 x86_64_linux:  "1ec9f8a3fc1785a03ab803fb13079ce290efb901932bf4b1dd17a91bb974f7ad"
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

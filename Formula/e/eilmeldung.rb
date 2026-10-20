class Eilmeldung < Formula
  desc "Feature-rich TUI RSS reader"
  homepage "https://github.com/christo-auer/eilmeldung"
  url "https://github.com/christo-auer/eilmeldung/archive/refs/tags/1.9.1.tar.gz"
  sha256 "61ad045e3d829339f5e7ab5d071e6fac54a3ffe200042c98de8254bea004820f"
  license "GPL-3.0-or-later"
  head "https://github.com/christo-auer/eilmeldung.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e8a552ff526e3021c878fb50251896be41bcfa63f6cc1a3aaf12ade220ff349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34f1f219c91585cc0c09887d3280028cc6ad550aaf5793d4155c060a98f83cf9"
    sha256 cellar: :any,                 arm64_linux:   "f4787ec2eb0bf5f1a9ac653bfc356ea8004deefe931e050f64014c0d562b19ae"
    sha256 cellar: :any,                 x86_64_linux:  "81eb6d4847f3d2f8a19c11a76460dcc760bde3fb8f690b2539294894c60eb93c"
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

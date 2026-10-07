class Tattoy < Formula
  desc "Text-based compositor for modern terminals"
  homepage "https://github.com/tattoy-org/tattoy"
  url "https://github.com/tattoy-org/tattoy/archive/refs/tags/tattoy-v0.1.8.tar.gz"
  sha256 "bc8a1fbab1870b64faea6494ab202c08c57b062be17fab11d488ecd312963c46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7686d44cb915d5fd415b27fbd08055f26733e6570f91be3c85eed5588ebe18cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573f3f923452eef78393d3087aeaacdc24b632dd99976d9e7b790ef7794e9851"
    sha256 cellar: :any,                 arm64_linux:   "a369f7865a650f7301dc5a16ab016711c9e83a37f28bf500a233342dca52b99d"
    sha256 cellar: :any,                 x86_64_linux:  "440b1ddaab000fc7c8be47ee7821a800db4c2b4fb1fb65c0c9fbc0f4c533b7d2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tattoy")
  end

  test do
    require "pty"
    require "timeout"

    # tattoy opens the controlling terminal before parsing CLI args, so even
    # `--version` needs a TTY (no TTY: `os error 6`; inherited CI TTY can hang).
    output = +""
    Timeout.timeout(30) do
      PTY.spawn("stty cols 120 rows 40; exec #{bin}/tattoy --version") do |r, _w, pid|
        begin
          r.each_line { |line| output << line }
        rescue Errno::EIO
          # PTY closed after the process exited
        end
        Process.wait(pid)
      end
    end
    assert_match "tattoy #{version}", output
  end
end

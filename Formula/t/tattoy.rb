class Tattoy < Formula
  desc "Text-based compositor for modern terminals"
  homepage "https://github.com/tattoy-org/tattoy"
  url "https://github.com/tattoy-org/tattoy/archive/refs/tags/tattoy-v0.1.8.tar.gz"
  sha256 "bc8a1fbab1870b64faea6494ab202c08c57b062be17fab11d488ecd312963c46"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1546206318764a093a577261d18e8b6dc98db28aa1326333779d067c6f9997b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345130e7efcf3e69a645b38bd7f767535413ba4bde95df4ee7a57dd636e688d1"
    sha256 cellar: :any_skip_relocation, ventura:       "7b7179676032dd13cc7b7fd50cf225b8d255e9a3f78028056349a987f68ec36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2b5d9f1ee1cecb71b037c21d13f4ca56f94beb0d446f6b417abe6fce377551"
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

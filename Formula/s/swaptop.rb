class Swaptop < Formula
  desc "TUI for monitoring swap usage"
  homepage "https://github.com/luis-ota/swaptop"
  url "https://github.com/luis-ota/swaptop/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "9197ec8821c5705a972d763d9c5f715624f0a31a1dd72a88804306654b3a2c22"
  license "MIT"
  version_scheme 1
  head "https://github.com/luis-ota/swaptop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "9645bb9636e0f68de04f608e431e10527d5c5258b0097a2920a16cb4dd4ba887"
    sha256 cellar: :any, x86_64_linux: "ebc1382036ea76a68e8233cf795e489ec014f83e26720a57ee312fd3ad5a62df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    # Fix the stale swaptop version in the v1.0.6 lockfile (Cargo.toml is 1.0.6).
    # TODO: Remove in the next release.
    inreplace "Cargo.lock", "name = \"swaptop\"\nversion = \"1.0.5\"", "name = \"swaptop\"\nversion = \"1.0.6\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    # Upstream has no CLI flags; drive the TUI in a PTY and quit with `q`.
    output = +""
    PTY.spawn({ "TERM" => "xterm-256color", "XDG_CONFIG_HOME" => testpath.to_s },
              "/bin/sh", "-c", "stty cols 120 rows 40; exec #{bin}/swaptop") do |r, w, pid|
      Timeout.timeout(30) do
        loop do
          output << r.readpartial(4096)
          next unless output.include?(" swaptop ")

          w.write "q"
          break
        end

        loop { output << r.readpartial(4096) }
      rescue EOFError, Errno::EIO
        nil
      ensure
        begin
          Process.kill("TERM", pid)
        rescue Errno::ESRCH
          nil
        end
      end
    end

    assert_match " swaptop ", output
  end
end

class CcEnhanced < Formula
  desc "Unofficial terminal dashboard for Claude Code usage analytics"
  homepage "https://github.com/melonicecream/cc-enhanced"
  url "https://github.com/melonicecream/cc-enhanced/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "07110940672bb86e2c74c1e265741b8c60d603573f8c7d851dafbeb9f71ed201"
  license "GPL-3.0-or-later"
  head "https://github.com/melonicecream/cc-enhanced.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "135097c2ed35c72080bc9ed47645cc0af0821b28afcee5ed1d4419d3795bf1bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fae2307b1a4455b428b469806c94a3249597dcfad05690ac27ce6fecfd3ed557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d14ec78aa08a6b523fb007f25b46152c4ddec4091c32c3019b8ba9d03715a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b2b5a75df61d84c04e35137579c0d60c4f573184d353ae0d9adf70c193030c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31a3552bb627e63096f638e5be2c84da2ce7471488d8450c27f8d1f4d83b1363"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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

    claude_home = testpath/".claude"
    claude_home.mkpath
    (claude_home/"pricing_cache.json").write <<~JSON
      {
        "models": {},
        "last_updated": #{Time.now.to_i}
      }
    JSON

    output = +""
    PTY.spawn({ "TERM" => "xterm-256color" }, "/bin/sh", "-c",
              "stty cols 120 rows 40; exec #{bin}/cc-enhanced") do |r, w, pid|
      Timeout.timeout(15) do
        loop do
          output << r.readpartial(4096)
          next unless output.include?("Claude Code Enhanced")

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

    assert_match "Claude Code Enhanced", output
  end
end

class Jiggy < Formula
  desc "Minimalistic cross-platform mouse jiggler written in Rust"
  homepage "https://0xdeadbeef.info/"
  url "https://github.com/0xdea/jiggy/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "57a380ff224e9f4eeea2a0031d6b30c9cacbbf3ce7b56e99225d16d09e4d6fad"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e598bbf773daa3946707363d79ee44035348008b234e83d2335980fd26ec3b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ac4c476b566cc6f9c9a80684b35a8606bb86617e0b8244f4deaa762b34e8829"
    sha256 cellar: :any,                 arm64_linux:   "cb7ef8cdf3eb89911710354492a506f0705551a5c093e677f168fd99076ecfc8"
    sha256 cellar: :any,                 x86_64_linux:  "51d9966fa07ef4ab6bf6ed26336270f2b381dead5c86f3f12ab4ab49e9a66ed0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "xdotool"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiggy --version 2>&1", 1)

    # Error: DISPLAY environment variable is empty.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jiggy", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Just chillin' for 60s", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

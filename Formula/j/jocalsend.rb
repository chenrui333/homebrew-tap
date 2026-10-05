class Jocalsend < Formula
  desc "Rust terminal client for Localsend"
  homepage "https://git.kittencollective.com/nebkor/joecalsend"
  url "https://static.crates.io/crates/jocalsend/jocalsend-1.6.180339887.crate"
  sha256 "68d6873338af44ae4fd6437a77e46837d84fa45d771ffbb989329c15a770a8f7"
  # https://git.kittencollective.com/nebkor/joecalsend/src/branch/main/LICENSE.md
  # dual license
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe1b51a10578a7d79a041d07adf3b62549e2fbdbe30c2da8d661b9fbb85b71a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab603641aa265242375973566e6717a1acb1716865b3c27ed7b1393120bbb196"
    sha256 cellar: :any,                 arm64_linux:   "df28d3d746bb1df5d67b22e6f7bf58b43dede7b69cff4621d3f5705207eb1769"
    sha256 cellar: :any,                 x86_64_linux:  "38703b920bfd270c82a8028cb527ffeda80deefd03f70baa647b108e3508aff3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # The only runtime path starts the LAN service (UDP multicast bind on the local address); build stays offline.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jocalsend --version")

    # Skip linux CI test
    # `Error: IOError(Os { code: 2, kind: NotFound, message: \"No such file or directory\" })`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"jocalsend", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Incoming Transfer Requests", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

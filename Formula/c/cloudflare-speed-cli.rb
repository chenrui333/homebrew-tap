class CloudflareSpeedCli < Formula
  desc "Cloudflare-based speed test with optional TUI"
  homepage "https://github.com/kavehtehrani/cloudflare-speed-cli"
  url "https://github.com/kavehtehrani/cloudflare-speed-cli/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "d259b81f2641613192ef00612a58a817e3cb04e83ee56f8e2052d70cf403bf7f"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/kavehtehrani/cloudflare-speed-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93e33e6b5ab35da3235815fed6954db6ee324266bc7da088ee5ab155d3919fce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "442269a20278f1cfe8023e504a9d8b9e13885acb5a19b62956b4215dcaa02164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "079fa55462bd7038d2c1cc2d5d94a76f3d92eb9a064b2e9b4b6c330aaeaf8fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ccc11cc86af6b7aa42841352a9633388a059ff04d9d98f92344f9db16c72d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a681e42bc9d48eb881d5ce774e3e6031d6adf39c3638e65bc234eccbdba6f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudflare-speed-cli --version")

    output = shell_output("#{bin}/cloudflare-speed-cli --silent 2>&1", 1)
    assert_match "--silent can only be used with --json", output
  end
end

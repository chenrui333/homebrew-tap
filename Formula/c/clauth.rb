class Clauth < Formula
  desc "Multi-account manager and usage monitor for Claude Code"
  homepage "https://github.com/uwuclxdy/clauth"
  url "https://github.com/uwuclxdy/clauth/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b89423c6095f1651f6ab4e0667505956a6ac7f1ecacb59b8013d9ad2dfea7cd5"
  license "MIT"
  head "https://github.com/uwuclxdy/clauth.git", branch: "mommy"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ca9cb10df77a74a98489338864cc7887e35eafa5ba4774707aba611213253f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bddbb0d6ed46ffc4eee3bee88c63c394fa9df8842f103bb4dbb00b5f359ee8ab"
    sha256 cellar: :any,                 arm64_linux:   "1b213fe91dc0a0b4b341ad0700a5ad318332e268ed384c0c7ef9bc8282cf2d01"
    sha256 cellar: :any,                 x86_64_linux:  "75d74500ef839f49c6175166fd303160f136df4bda9703234584a9b3140bd28d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Homebrew manages upgrades, so disable the background self-updater.
    inreplace "src/update.rs", 'env::var(NO_UPDATE_ENV).as_deref() != Ok("1")', "false"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"clauth", "completions")
  end

  service do
    run [opt_bin/"clauth", "daemon", "--standby"]
    keep_alive true
    log_path var/"log/clauth.log"
    error_log_path var/"log/clauth.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clauth --version")
    assert_match "no accounts yet. add one with `clauth login <name>`.", shell_output("#{bin}/clauth list")
    assert_empty JSON.parse(shell_output("#{bin}/clauth jobs --json"))
  end
end

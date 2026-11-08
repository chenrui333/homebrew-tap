class Clauth < Formula
  desc "Multi-account manager and usage monitor for Claude Code"
  homepage "https://github.com/uwuclxdy/clauth"
  url "https://github.com/uwuclxdy/clauth/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "2f3efd3f27bbb714bda4eb18da92e56dfbe9088ffe00e4efbf63ab0c04f8ca99"
  license "MIT"
  head "https://github.com/uwuclxdy/clauth.git", branch: "mommy"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95084f559cd43234691f49bfa327f5720567ccb5cac5997f6e1e46a3f6d7dc41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bd8b4111e4fca0bf1f6ea7d160bda5a260feb2724b2b4e14274051db824219b"
    sha256 cellar: :any,                 arm64_linux:   "9de4514bb901cd4ae16061b53a2434b7c8579d2774a98714886d35e4bee82ae2"
    sha256 cellar: :any,                 x86_64_linux:  "3210df2eccae62dcb3b74b512f960d4a2563605bd635c66e76ca8df239ed22a4"
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

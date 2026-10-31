class TerminalUse < Formula
  desc "Headless virtual terminal for AI agents"
  homepage "https://github.com/flipbit03/terminal-use"
  url "https://github.com/flipbit03/terminal-use/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c6011385a746ab6f3cdc208237159398b0a29ed0bf1c873235305e6c8738952a"
  license "MIT"
  head "https://github.com/flipbit03/terminal-use.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eab68acf8f66054e31ed4c418538b589104547ae81e5f1d77d87739ed6d881f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c5f1a19097cdc5f17ea7186a5561eb3eab71f477e33013909c7a0c4b02e570"
    sha256 cellar: :any,                 arm64_linux:   "2463a8c2e556e260ec74f52397906f2fd20adcbf3c245fb06b6448b764b356de"
    sha256 cellar: :any,                 x86_64_linux:  "4be34e9065bf9b1b66fc602b837a807702265ebad8882ad6aee9666d1bd3ac9e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # Match the version stamping done by upstream's release workflow.
    inreplace "Cargo.toml", 'version = "0.0.0"', "version = \"#{version}\""
    inreplace "Cargo.lock", /(name = "terminal-use"\nversion = )"0\.0\.0"/, "\\1\"#{version}\""
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Homebrew owns this executable; retain update checks but never overwrite it.
    inreplace "src/commands/self_cmd.rs", "async fn run_update(args: UpdateArgs) -> Result<()> {", <<~RUST.chomp
      async fn run_update(args: UpdateArgs) -> Result<()> {
          if !args.check {
              anyhow::bail!("Installed with Homebrew; run `brew upgrade terminal-use` to update.");
          }
    RUST
    system "cargo", "install", *std_cargo_args, "--bin", "tu"
  end

  service do
    run [opt_bin/"tu", "daemon", "start"]
    keep_alive true
    log_path var/"log/terminal-use.log"
    error_log_path var/"log/terminal-use.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tu --version")

    ENV["XDG_RUNTIME_DIR"] = testpath.to_s
    daemon_pid = spawn bin/"tu", "daemon", "start", [:out, :err] => (testpath/"daemon.log").to_s
    100.times do
      break if (testpath/"tu.sock").exist?

      sleep 0.1
    end
    assert_path_exists testpath/"tu.sock"
    system bin/"tu", "run", "--name", "homebrew", "--", "/bin/sh", "-c", "printf homebrew-terminal-fixture"
    system bin/"tu", "wait", "--name", "homebrew", "--text", "homebrew-terminal-fixture"
    assert_match "homebrew-terminal-fixture", shell_output("#{bin}/tu screenshot --name homebrew")
  ensure
    if daemon_pid
      system bin/"tu", "daemon", "stop"
      Process.wait(daemon_pid)
    end
  end
end

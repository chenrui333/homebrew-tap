class AiMemory < Formula
  desc "Long-term memory for AI coding agents"
  homepage "https://github.com/akitaonrails/ai-memory"
  url "https://github.com/akitaonrails/ai-memory/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "10e55811d760f20dcb2cce01b24ba2c46f79fc8de95370d8816cd3549e05e985"
  license "MIT"
  head "https://github.com/akitaonrails/ai-memory.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a3e1d61e2edd179c1aa2606418265c1268aaadc9ffc0064be68b286cc2264541"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "383c6574e5923b471b3456269f32eb314c24d9b425b7cbe6bfcb0777c0e19e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edb4e35a372482a14e073194c26270b8152c5d2acca8b4cb65fb34173305c876"
    sha256 cellar: :any,                 arm64_linux:   "ec31b0549fd6784c83f421b0e0c7cdc61ed30d286288326f8b54474843ea1499"
    sha256 cellar: :any,                 x86_64_linux:  "f536421b14055384de6936d13c01dba92d32d65d28f721f0a385d19ff636a3b1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Agent settings must survive cleanup of old versioned Cellar directories.
    inreplace "crates/ai-memory-cli/src/commands/render_shared.rs",
              "embedded_exe_from(std::env::current_exe().ok())",
              "PathBuf::from(\"#{opt_bin}/ai-memory\")"
    # The tagged source includes its generated stylesheet; the normal build
    # embeds the full web UI without downloading the standalone Tailwind binary.
    system "cargo", "install", *std_cargo_args(path: "crates/ai-memory-cli")
    # Upstream discovers this standard prefix layout relative to current_exe().
    pkgshare.install "hooks"
    generate_completions_from_executable(bin/"ai-memory", "completions")
  end

  service do
    run [opt_bin/"ai-memory", "serve", "--transport", "http", "--enable-web"]
    keep_alive true
    working_dir var
    log_path var/"log/ai-memory.log"
    error_log_path var/"log/ai-memory.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ai-memory --version")

    settings = testpath/"claude-settings.json"
    settings.write '{"hooks":{}}'
    args = ["--data-dir", testpath/"data", "install-hooks", "--agent", "claude-code",
            "--apply", "--config-file", settings]
    system bin/"ai-memory", *args
    installed = JSON.parse(settings.read)
    assert installed.fetch("hooks").key?("SessionStart")
    assert_match (opt_bin/"ai-memory").to_s, settings.read
    system bin/"ai-memory", *args
    assert_equal installed, JSON.parse(settings.read)
  end
end

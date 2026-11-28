class AiMemory < Formula
  desc "Long-term memory for AI coding agents"
  homepage "https://github.com/akitaonrails/ai-memory"
  url "https://github.com/akitaonrails/ai-memory/archive/refs/tags/v3.6.5.tar.gz"
  sha256 "76c12c63b02c1e4d7f1733dfa988d6c7fb09086e6606f3ee46cd9d6c1d95b952"
  license "MIT"
  head "https://github.com/akitaonrails/ai-memory.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1cef67a930bff636c66a120ef1a3e081aec35e74924f4073a6776d6d0ba3f804"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4320a38171d4c0b62c5541efeb8df89d3f330ef46689ff01fa649d5b75907c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8734ad01aa743eca2667ad68f11131ddf3ecc62bf00519279b96424f7e1b9fe"
    sha256 cellar: :any,                 arm64_linux:   "b7f1276c1b891c6ff3d9431f493115debf6bad27238ed5655825d33b8489afa6"
    sha256 cellar: :any,                 x86_64_linux:  "5619a58cf4dd125c6a669a7d194716310fb365acc871a8ee7d5e19b26e9b2b53"
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

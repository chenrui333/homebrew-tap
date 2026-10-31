class AiMemory < Formula
  desc "Long-term memory for AI coding agents"
  homepage "https://github.com/akitaonrails/ai-memory"
  url "https://github.com/akitaonrails/ai-memory/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "e4193a11221daca14a4dafb4048f7aa73bf25aee8de7e0c7687cdef541f84f2c"
  license "MIT"
  head "https://github.com/akitaonrails/ai-memory.git", branch: "main"

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

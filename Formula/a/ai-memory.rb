class AiMemory < Formula
  desc "Long-term memory for AI coding agents"
  homepage "https://github.com/akitaonrails/ai-memory"
  url "https://github.com/akitaonrails/ai-memory/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "9db9a04b7fcb8d320a4fa917c41138d8e96b699f3573c719d3632726a1c361a3"
  license "MIT"
  head "https://github.com/akitaonrails/ai-memory.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9049b9638dadbf45b9198251b2fbbaff085d03ca769f4b655915be385ae41068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9192c18809d6c51f9b1838d02cb4920eee4ba1dc1a640c9c4c82e19d167f1759"
    sha256 cellar: :any,                 arm64_linux:   "03f0da16099359238b7728b5b0e0a38c8a9bfc1b340ef46e14c75e5fae3496f1"
    sha256 cellar: :any,                 x86_64_linux:  "8b90d513b0b498661fd7547220930a3be76ddab647ae23c4f0b3658c0eb21f4d"
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

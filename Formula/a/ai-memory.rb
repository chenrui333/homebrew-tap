class AiMemory < Formula
  desc "Long-term memory for AI coding agents"
  homepage "https://github.com/akitaonrails/ai-memory"
  url "https://github.com/akitaonrails/ai-memory/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "10e55811d760f20dcb2cce01b24ba2c46f79fc8de95370d8816cd3549e05e985"
  license "MIT"
  head "https://github.com/akitaonrails/ai-memory.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "693244eb3b1758babb9fe794728d8fddd04c5cc1c5e61fb3d3a7f203d997c246"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7214a3377b85be7bbafaaeb88ac6eadb0a9694481f5cda1ec580ceb31dc42ced"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0cd76670ce2abb25483c8aa6782d4fd32b8e8e7badee6fc9cc507a460bcdef7"
    sha256 cellar: :any,                 arm64_linux:   "06c851cf0351b2223415f42cd9a4c777181ac292b3cefd645765c478c93fed75"
    sha256 cellar: :any,                 x86_64_linux:  "e2406a9565f1847bca629c80b096889fdf8d38f69cabca056902f455066ed86b"
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

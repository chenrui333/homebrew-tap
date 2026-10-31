class LeanCtx < Formula
  desc "Context compression, memory, and routing engine for AI agents"
  homepage "https://leanctx.com"
  url "https://github.com/yvgude/lean-ctx/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "409dc12a57ddc38577dea2e4cea90ea66f9743e6be0215140d874f716d73157a"
  license "Apache-2.0"
  head "https://github.com/yvgude/lean-ctx.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    # Avoid an expensive single-threaded fat-LTO link on ARM builders.
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "off"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "16"
    system "cargo", "install", *std_cargo_args(path: "rust")
    generate_completions_from_executable(bin/"lean-ctx", "completions")
  end

  service do
    run [opt_bin/"lean-ctx", "serve", "--_foreground-daemon"]
    keep_alive true
    log_path var/"log/lean-ctx.log"
    error_log_path var/"log/lean-ctx.log"
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/lean-ctx --version")
    ENV["XDG_CACHE_HOME"] = testpath/"cache"
    runtime = shell_output("#{bin}/lean-ctx embeddings status")
    assert_match "version #{Formula["onnxruntime"].version}", runtime
    refute_path_exists testpath/"cache/lean-ctx/models"

    (testpath/"example.rs").write <<~RUST
      // A fixture comment that compression should remove.
      pub fn greeting(name: &str) -> String {
          // Build a friendly message for the caller.
          let message = format!("Hello, {}!", name);
          message
      }
    RUST
    result = JSON.parse(shell_output("#{bin}/lean-ctx compress diff example.rs --json"))
    diff = result.fetch("diff")
    assert_match(%r{^-\d+: // A fixture comment that compression should remove\.$}, diff)
    assert_match(%r{^-\d+: +// Build a friendly message for the caller\.$}, diff)
    added_lines = diff.lines.grep(/^\+\d+:/).join
    assert_match 'let message = format!("Hello, {}!", name);', added_lines
    assert_match(/^\+\d+: +message$/, added_lines)
    refute_match "//", added_lines
    refute_match(/^-\d+:.*pub fn greeting/, diff)
  end
end

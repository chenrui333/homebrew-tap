class Llamastash < Formula
  desc "Terminal-native local LLM orchestrator and proxy"
  homepage "https://github.com/llamastash/llamastash"
  url "https://github.com/llamastash/llamastash/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "af28a44b2356d93e834da3eb189f79bb375b35e60bf6f684fe657547b01dd08e"
  license "MIT"
  head "https://github.com/llamastash/llamastash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efea440ef7bb99f2fd0089d5645fe012fd31740fd4c0db3bd7ae179e76fabe0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "059dbd941cf305dedb68be5546f07ef2bf0807147f4002610b146087a997301f"
    sha256 cellar: :any,                 arm64_linux:   "038ce0c99c47d44f0095ee5e045f69d2c51057505d8a7c408baa8efc40ab8140"
    sha256 cellar: :any,                 x86_64_linux:  "036339ce7b5f48643060175df69420654b17453a68320cbf12ba424f77a8c17b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "llama.cpp"

  on_linux do
    depends_on "wayland"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"llamastash", "completions")
  end

  service do
    run [opt_bin/"llamastash", "--llama-server", formula_opt_bin("llama.cpp")/"llama-server",
         "daemon", "start", "--foreground"]
    keep_alive true
    log_path var/"log/llamastash.log"
    error_log_path var/"log/llamastash.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llamastash --version")
    output = JSON.parse(shell_output("#{bin}/llamastash knobs --backend llamacpp --json"))
    assert_equal "llamacpp", output.fetch("backends").first.fetch("backend")
    split_mode = output.fetch("backends").first.fetch("knobs").find { |knob| knob["id"] == "split-mode" }
    assert_equal %w[none layer row tensor], split_mode.fetch("choices")
  end
end

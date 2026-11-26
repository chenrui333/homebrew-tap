class Icm < Formula
  desc "Persistent memory with hybrid search for AI agents"
  homepage "https://github.com/rtk-ai/icm"
  url "https://github.com/rtk-ai/icm/archive/refs/tags/icm-v0.11.6.tar.gz"
  sha256 "23de5bf821352e88aca320657a4d9b0ee3f58d48dedf79e08ac814d8f2a364ee"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/icm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7504534ca38df694cccd4942c72ae429bf81b9eeaed3f03fced604f10221c978"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f86436773f3f34b1d7259b8b365a935bde818dfab5bd7563af6bf1e155d2cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7edb2e2e7b95382d80878b716345e60426d14f2c6d9ae2337f8ce79ca614b6a0"
    sha256 cellar: :any,                 arm64_linux:   "cd28d240df2b17fc6e65b52c2e615d72cc73c98fd368c74a996c12ac2d18791b"
    sha256 cellar: :any,                 x86_64_linux:  "c8aa28828d5dd69de7fc078e3972d7835cc54c840e7c0d9fd37f7cef4afd2049"
  end

  depends_on "bun" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "crates/icm-cli/web" do
      system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile"
    end
  end

  def install
    cd "crates/icm-cli/web" do
      system formula_opt_bin("bun")/"bun", "run", "--bun", "build"
    end

    # Use Homebrew's ONNX Runtime instead of downloading a prebuilt library.
    # Retain every default storage backend, TUI, HTTP API, and the built web UI.
    features = %w[embeddings-dynamic tui http-api backend-sqlite postgres opensearch web]
    system "cargo", "install", *std_cargo_args(path: "crates/icm-cli"),
           "--no-default-features", "--features", features.join(",")
    libexec.install bin/"icm"
    ort_library = formula_opt_lib("onnxruntime")/shared_library("libonnxruntime")
    (bin/"icm").write_env_script libexec/"icm", ORT_DYLIB_PATH: "${ORT_DYLIB_PATH:-#{ort_library}}"
  end

  service do
    run [opt_bin/"icm", "serve", "--http", "127.0.0.1:3000"]
    keep_alive true
    log_path var/"log/icm.log"
    error_log_path var/"log/icm.log"
  end

  test do
    require "json"

    assert_match version.to_s, shell_output("#{bin}/icm --version")
    database = testpath/"memories.db"
    system bin/"icm", "--db", database, "--no-embeddings", "store",
           "--topic", "homebrew", "--content", "Homebrew xenolith fixture memory"
    result = JSON.parse(shell_output("#{bin}/icm --db #{database} --no-embeddings recall xenolith --format json"))
    assert_equal 1, result.length
    assert_match "Homebrew xenolith fixture memory", result.first.to_json
    assert_path_exists database
  end
end

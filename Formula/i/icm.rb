class Icm < Formula
  desc "Persistent memory with hybrid search for AI agents"
  homepage "https://github.com/rtk-ai/icm"
  url "https://github.com/rtk-ai/icm/archive/refs/tags/icm-v0.11.5.tar.gz"
  sha256 "0ddf1ec04a21e672977255654c81d60b4da440040dca1e6269714d7226c629fe"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/icm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce404774904cb25da0831953127b837e13f6d96781d74b13e309bebafdc54c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7894f152ef0b0c9ac4ba9f597a53206e67e525ba3c409e1dab30c8bdba5e9228"
    sha256 cellar: :any,                 arm64_linux:   "ef43b8a082c8bb5549bc7b640391809a4fdc9603194d03d70adbbd9c4400ab57"
    sha256 cellar: :any,                 x86_64_linux:  "27a7a747dbd75daaf1cbcb039a92fc553dcefd0c1f74820ccc35dc4f8a1a1f9b"
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

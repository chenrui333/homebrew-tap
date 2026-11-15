class Localgpt < Formula
  desc "Local AI assistant with persistent memory, autonomous tasks, and semantic search"
  homepage "https://localgpt.app"
  url "https://github.com/localgpt-app/localgpt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "130ffdf6b5fa418ea4c94baabdf0674bac9e00824bc3e18229582952494f60f8"
  license "Apache-2.0"
  head "https://github.com/localgpt-app/localgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10c6d93b6951d6855a9955815903010af2ccc74605d4127ef394b80433696e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7917755871721708d238d9b80440ebc98d14b30083b135103cd897d5f9f99330"
    sha256 cellar: :any,                 arm64_linux:   "f658716e2d0176791be3b52058b5407c88237d45440de9e2d3952a5b5c81c86b"
    sha256 cellar: :any,                 x86_64_linux:  "dd94724ab5cbd883add1cc42519f25b409a1928d3a8bba7125ec1355507b70f2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "wayland"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Link brewed libraries instead of downloading ONNX or vendoring OpenSSL.
    inreplace "Cargo.toml", '"native-tls-vendored"', '"native-tls"'
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV["ORT_SKIP_DOWNLOAD"] = "1"
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-rpath,#{formula_opt_lib("onnxruntime")}"

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"localgpt", "completion")
  end

  service do
    run [opt_bin/"localgpt", "daemon", "start", "--foreground"]
    keep_alive true
    log_path var/"log/localgpt.log"
    error_log_path var/"log/localgpt.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/localgpt --version")
    system bin/"localgpt", "world", "init", testpath/"example.world"
    assert_match "no history yet", shell_output("#{bin}/localgpt world tips #{testpath}/example.world")
    system bin/"localgpt", "world", "verify", testpath/"example.world"
    assert_match "the batch isn't JSON",
                 shell_output("#{bin}/localgpt world submit #{testpath}/example.world invalid 2>&1", 1)
  end
end

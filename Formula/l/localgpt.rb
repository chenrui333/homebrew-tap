class Localgpt < Formula
  desc "Local AI assistant with persistent memory, autonomous tasks, and semantic search"
  homepage "https://localgpt.app"
  url "https://github.com/localgpt-app/localgpt/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "bba233af431fad60341ea61420f36f09d9ea096b9f5c054f054b28a143bef3ec"
  license "Apache-2.0"
  head "https://github.com/localgpt-app/localgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6675187643ec71dcab849054ea08c38edd638d3a95aefe6809096d3931a20fdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d986c85a72438734326ad5d5e361a76bc5d7805a11151903d7337a71676d5e"
    sha256 cellar: :any,                 arm64_linux:   "fd767ba4c139376dbe530f2304e387adceb99e138b02567a6739ce6ad97b8297"
    sha256 cellar: :any,                 x86_64_linux:  "5bc9567f3122b131bafd452483573719642d9ce5dbb588833d464eb7f2bdadec"
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

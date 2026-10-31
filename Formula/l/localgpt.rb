class Localgpt < Formula
  desc "Local AI assistant with persistent memory, autonomous tasks, and semantic search"
  homepage "https://localgpt.app"
  url "https://github.com/localgpt-app/localgpt/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "2d1c399db12223efc9d2134ddd77be783501522f84f92e625c90cc5bfaed6906"
  license "Apache-2.0"
  head "https://github.com/localgpt-app/localgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76992e4e6c788b00ddef17c2a8b034203c68babfffdf0e2184e6a02583532454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af69fb0341e2a67d4af4768605671279a09687cccade7597a9089e8e7eea90c"
    sha256 cellar: :any,                 arm64_linux:   "654c1bc194cce4a9db48570535e2518b02cadf5be1656b24b7f1a01e4e4e558d"
    sha256 cellar: :any,                 x86_64_linux:  "0dff8dd5f2c20e6e5846a5eb8f70c419960123acd1e85687ad29998cd8e873d6"
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

class Localgpt < Formula
  desc "Local AI assistant with persistent memory, autonomous tasks, and semantic search"
  homepage "https://localgpt.app"
  url "https://github.com/localgpt-app/localgpt/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5555908f6ed7b5dde1dbf2f6e57a8b3e47d1a9eafc18a701f4508adfb381fd96"
  license "Apache-2.0"
  head "https://github.com/localgpt-app/localgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ca359d9b3c4f2e84fe335caf05e7a4b7dc5fe960a352d045c4e6fd8448bc58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d7d66bc698a19dddf8390dabc75341fb8e6c48aa31431afafe4ecdd1ef2f3e"
    sha256 cellar: :any,                 arm64_linux:   "0a60c4fd19fa72eb880683ab8ddcf649e8fb3e1d5e1ad3afdeafdf7fff9a48b2"
    sha256 cellar: :any,                 x86_64_linux:  "88c614cd92ae2a59b72b3d62ae38bee125f5d883965895d8dee4c7b713b0d3d4"
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

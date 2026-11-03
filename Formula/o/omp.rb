class Omp < Formula
  desc "Terminal coding agent with multi-model support and native tools"
  homepage "https://omp.sh"
  url "https://github.com/can1357/oh-my-pi/archive/refs/tags/v18.16.0.tar.gz"
  sha256 "cdc22c255b651258038ac92f7b2aecbe464ecb90b8656957080cbd60872ced2a"
  license "MIT"
  head "https://github.com/can1357/oh-my-pi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "043d374296e908bb186d6c43dc364bd2a582658d51e251bf6486fa6599651674"
    sha256 arm64_sequoia: "ac1fbed54e74c21dd70af03a4e73a24ccc779526bf7ba665f7f69af766048700"
    sha256 arm64_linux:   "7580fb60634e4b71d173ab0186c28dcd28c2188e8a1b9417063021f5733d01a7"
    sha256 x86_64_linux:  "cbb5db909a19a2bb776d97d9bad53aeb829966aa967a14565ad9b39d09e6596a"
  end

  depends_on "bun" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "zig" => :build

  on_linux do
    # Standalone Bun executables retain the Linux runtime template's ICU linkage.
    depends_on "icu4c@79"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  # The upstream smoke test starts worker and dashboard servers on loopback.
  allow_network_access! :test
  deny_network_access! :build

  def fetch
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
    # NAPI's cargo metadata resolves every target, including Android-only dependency records.
    system "cargo", "fetch", "--locked"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    # Upstream enables smallvec specialization; use the brewed compiler rather than rustup.
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["OMP_NATIVE_CARGO_PROFILE"] = "ci"
    ENV["OMP_NATIVE_FEATURES"] = "wayland-pipewire" if OS.linux?
    ENV["PI_SKIP_VERSION_CHECK"] = "1"
    ENV["BUN_COMPILE_EXECUTABLE_PATH"] = bun.to_s

    # This upstream path generates bindings/enums, stamps the addon, and embeds it in the CLI.
    system bun, "packages/natives/scripts/build-bindings.ts"
    system bun, "packages/coding-agent/scripts/generate-docs-index.ts", "--generate"
    # build-binary runs the real stats/export-viewer generators and embeds docs and virtual modules.
    system bun, "packages/coding-agent/scripts/build-binary.ts"
    libexec.install "packages/coding-agent/dist/omp"
    (bin/"omp").write_env_script libexec/"omp", PI_SKIP_VERSION_CHECK: "1"
    pkgshare.install "docs", "packages/coding-agent/examples"
    generate_completions_from_executable(bin/"omp", "completions")
  end

  # Run the browser relay in the foreground so launchd/systemd owns its lifecycle.
  service do
    run [opt_bin/"omp", "browser-relay", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/omp.log"
    error_log_path var/"log/omp.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omp --version")
    # Checks real worker startup/IPC, isolated subprocess mode, and embedded dashboard HTML over loopback.
    assert_match "smoke-test: ok", shell_output("#{bin}/omp --smoke-test")
  end
end

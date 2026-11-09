class Omp < Formula
  desc "Terminal coding agent with multi-model support and native tools"
  homepage "https://omp.sh"
  url "https://github.com/can1357/oh-my-pi/archive/refs/tags/v18.18.3.tar.gz"
  sha256 "1bcfc6d984d7280e6ed0163f212297f382e4b8afe5c7b3a6b3f6822ad4e7aae6"
  license "MIT"
  head "https://github.com/can1357/oh-my-pi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "e5937d4f179e542ad9cbe3a1faf78e539bc3dc54459c312d53938437d07a8062"
    sha256 arm64_sequoia: "acaffa189da7b2f1e05e6a675e95152102953e35a2faa9bd53b4ef3bc7b26a9a"
    sha256 arm64_linux:   "52696947d29a690a6fc921ac48c246950696356704d846e4a1d7cd36f79497f7"
    sha256 x86_64_linux:  "04e96adb91c3af1b087e0f9d92e7dcd8112d1f2ca226c06ef37cdc8aeaf09258"
  end

  depends_on "bun" => :build
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "rustup" => :build
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

  def rust_toolchain
    Utils.safe_popen_read(formula_opt_bin("python@3.14")/"python3.14", "-c", <<~PYTHON).strip
      import tomllib
      with open("rust-toolchain.toml", "rb") as config:
          print(tomllib.load(config)["toolchain"]["channel"])
    PYTHON
  end

  def fetch
    # Stage upstream's pinned toolchain without changing the user's rustup state.
    ENV["RUSTUP_HOME"] = buildpath/".rustup"
    rustup = formula_opt_bin("rustup")/"rustup"
    toolchain = rust_toolchain
    system rustup, "toolchain", "install", toolchain, "--profile", "minimal", "--no-self-update"
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
    # NAPI's cargo metadata resolves every target, including Android-only dependency records.
    system rustup, "run", toolchain, "cargo", "fetch", "--locked"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    ENV["RUSTUP_HOME"] = buildpath/".rustup"
    cargo = Pathname(Utils.safe_popen_read(formula_opt_bin("rustup")/"rustup",
                                         "which", "--toolchain", rust_toolchain, "cargo").strip)
    ENV.prepend_path "PATH", cargo.dirname
    ENV["CARGO"] = cargo
    ENV["RUSTC"] = cargo.dirname/"rustc"
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

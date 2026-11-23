class Omp < Formula
  desc "Terminal coding agent with multi-model support and native tools"
  homepage "https://omp.sh"
  url "https://github.com/can1357/oh-my-pi/archive/refs/tags/v19.1.1.tar.gz"
  sha256 "6663c9455a8a3eaec97870b21c3a917918ce24a62453ed1e51ed767261928a2d"
  license "MIT"
  head "https://github.com/can1357/oh-my-pi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7768c2aa8963933637cb49d6e6b7c3c64870a97571246c4e9a056a36f8a082c3"
    sha256 arm64_tahoe:   "86015498cb82fb0878b76115019e9d016efde2af8a2fe742adec83488cceb795"
    sha256 arm64_sequoia: "5ca9e100364e82644b08be2ac0f2513d66b7ebe19d47d8e2e128216bad9ddf66"
    sha256 arm64_linux:   "61a4f26d675c43529313a4ef5ef01ddd2fea627521f7cda36f93f61852278f60"
    sha256 x86_64_linux:  "d4fb8d6a3ad72316d00968fe207322c2475488f00f8f6c193a9838caf6da94ab"
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

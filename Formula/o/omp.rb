class Omp < Formula
  desc "Terminal coding agent with multi-model support and native tools"
  homepage "https://omp.sh"
  url "https://github.com/can1357/oh-my-pi/archive/refs/tags/v18.22.0.tar.gz"
  sha256 "73f9fb46e33fe48062053749a3cefe405ab06b05f8d3b8e3c203bb8a3003d113"
  license "MIT"
  head "https://github.com/can1357/oh-my-pi.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "277247fe877f9b3b4a1e5de9c2ff21bede643a7b78d07fea0e6df155df95a7c8"
    sha256 arm64_sequoia: "7d749b4fcf728151a37010de3f68662c9da4f905dda81309b657148d40bdf83e"
    sha256 arm64_linux:   "c42e7239955870ae53f6e4760b42aac625eba0e3af5bf70b579f0589c85e7bab"
    sha256 x86_64_linux:  "c6f9ec4f03d6a1cd4a8177b1015f5c256741f5fc7610b4bb62f6f30e35cb46ce"
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

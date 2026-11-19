class KilocodeCli < Formula
  desc "AI coding agent with a terminal UI, local console, and sandboxed tools"
  homepage "https://kilo.ai/cli"
  url "https://github.com/Kilo-Org/kilocode/archive/refs/tags/v7.8.32.tar.gz"
  sha256 "2bfb7f84586997df0e72f47bb2590a8b80b8300d07420315bf4deb3299512591"
  license "MIT"
  head "https://github.com/Kilo-Org/kilocode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "422f37a834e2f3a8d04d1f451513a503c9ff1ba603bd27b0ae9c329103dd2e4e"
    sha256 arm64_sequoia: "d58425e5ef3dff0d3b62e13daa31e0a0dcec420e3d4ce35f60d9612021d3974d"
    sha256 arm64_linux:   "2abac6c990fb84fd051547c22570aba66c10e4c41b9ddc53bf4307a212b124c1"
    sha256 x86_64_linux:  "e7f8f6bde7754529e0bef5666b870f9f79e66bf8204cb61a377052b6c6f5f947"
  end

  depends_on "bun" => :build
  depends_on "node" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "bubblewrap"
    depends_on "chenrui333/tap/sandbox-runtime"
    # Standalone Bun executables retain the Linux runtime template's ICU linkage.
    depends_on "icu4c@79"
    depends_on "libseccomp"
    depends_on "socat"
  end

  # Allow package builders to use their verified host Bun: https://github.com/Kilo-Org/kilocode/pull/16539
  patch do
    url "https://github.com/Kilo-Org/kilocode/commit/b9bae5e0c4682970fcd2594e3c057d0eb76156f3.patch?full_index=1"
    sha256 "2304e12011fed620f4bc9f7e3a59e510b98fd5776f74c19d8d40b8fcb0ca47e9"
  end

  deny_network_access!

  def fetch
    bun = formula_opt_prefix("bun").realpath/"bin/bun"
    system bun, "install", "--frozen-lockfile", "--ignore-scripts"
    # Upstream embeds the live provider catalog; download it during fetch, never during build.
    system "curl", "-fsSL", "https://models.dev/api.json", "-o", buildpath/"models-dev-api.json"
  end

  def install
    bun = formula_opt_bin("bun")/"bun"
    ENV["KILO_VERSION"] = version.to_s
    ENV["KILO_CHANNEL"] = "latest"
    ENV.delete "KILO_RELEASE"
    ENV["MODELS_DEV_API_JSON"] = buildpath/"models-dev-api.json"
    ENV["KILO_SKIP_BUNDLED_BWRAP"] = "1"
    ENV["KILO_USE_HOST_BUN"] = "1"

    if OS.linux?
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      source = formula_opt_libexec("chenrui333/tap/sandbox-runtime")/
               "lib/node_modules/@anthropic-ai/sandbox-runtime/vendor/seccomp/#{arch}/apply-seccomp"
      sandbox_pattern = "node_modules/.bun/@anthropic-ai+sandbox-runtime@*/node_modules/" \
                        "@anthropic-ai/sandbox-runtime"
      buildpath.glob(sandbox_pattern).each do |pkg|
        target = pkg/"vendor/seccomp/#{arch}/apply-seccomp"
        rm target
        ln_s source, target
      end
    end
    system bun, "run", "--cwd", "packages/opencode", "build", "--single", "--skip-install"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    libexec.install buildpath.glob("packages/opencode/dist/@kilocode/cli-#{platform}-#{arch}/bin/*")
    (bin/"kilo").write_env_script libexec/"kilo",
      PATH: "#{formula_opt_bin("ripgrep")}:$PATH"
    bin.install_symlink "kilo" => "kilocode"
    generate_completions_from_executable(bin/"kilo", "completion", shell_parameter_format: :none, shells: [:bash])
  end

  service do
    run [opt_bin/"kilo", "serve", "--hostname", "127.0.0.1", "--port", "4096"]
    keep_alive true
    working_dir var
    log_path var/"log/kilocode-cli.log"
    error_log_path var/"log/kilocode-cli.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kilo --version")
    ENV["KILO_DISABLE_MODELS_FETCH"] = "1"
    ENV["KILO_DISABLE_PROJECT_CONFIG"] = "1"
    ENV["KILO_CONFIG_CONTENT"] = '{"enabled_providers":["anthropic"]}'
    ENV["ANTHROPIC_API_KEY"] = "homebrew-offline-test"
    assert_match "anthropic/", shell_output("#{bin}/kilocode --pure models anthropic")
  end
end

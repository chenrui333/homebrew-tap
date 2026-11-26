class KilocodeCli < Formula
  desc "AI coding agent with a terminal UI, local console, and sandboxed tools"
  homepage "https://kilo.ai/cli"
  url "https://github.com/Kilo-Org/kilocode/archive/refs/tags/v7.8.36.tar.gz"
  sha256 "ccc03bb6a4f5c503439921c35f691ebb3f2424be2984f1a7ef46f7cc9297b80e"
  license "MIT"
  head "https://github.com/Kilo-Org/kilocode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "0dbc87191b86a249d0e9a04bb6ee73396d92ada1ead9598a9844f18cec38b20d"
    sha256 arm64_tahoe:   "4e15b74e18502db65b0527e0c77e97addd7b4f7551771bb0513a2e39f6eb92ad"
    sha256 arm64_sequoia: "94c71570c87de9fcb2e535f9da9cac60dd73c646886a7fe1424f890793db61ee"
    sha256 arm64_linux:   "c61655d231ef1d98914d5aa7c8c0ad8db539be20bc000d8890662cec6a962a80"
    sha256 x86_64_linux:  "c223a606eb89f197d4abbcba585997e21913ff0c945e3294f39de4a9e7c968ba"
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

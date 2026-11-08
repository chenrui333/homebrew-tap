class KilocodeCli < Formula
  desc "AI coding agent with a terminal UI, local console, and sandboxed tools"
  homepage "https://kilocode.ai/cli"
  url "https://github.com/Kilo-Org/kilocode/archive/refs/tags/v7.8.28.tar.gz"
  sha256 "e891d9150e94e0a95781b733494803884152800fa0ec8587610973fb659dab43"
  license "MIT"
  head "https://github.com/Kilo-Org/kilocode.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "96565745936b104f341b8dffab39ab872a970a896d9af410dfc67ea2890deab4"
    sha256 arm64_sequoia: "02beb1f40352d3f225a3592a9e52fe44811a64eefaf2cef4c70c99e1a68f2efe"
    sha256 arm64_linux:   "2c98dd3d7b8d392d32cc7c2b06ef51db2e79f0cc0aa515314365e82885326810"
    sha256 x86_64_linux:  "a8a4efd9aa0973e234eee10ff163643ee9de05d140a20edcbc6c2007904777c7"
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

  deny_network_access!

  def fetch
    bun = formula_opt_prefix("bun").realpath/"bin/bun"
    system bun, "install", "--frozen-lockfile", "--ignore-scripts"
    # Upstream embeds the live provider catalog; download it during fetch, never during build.
    system "curl", "-fsSL", "https://models.dev/api.json", "-o", buildpath/"models-dev-api.json"
  end

  def install
    bun_prefix = formula_opt_prefix("bun").realpath
    bun = bun_prefix/"bin/bun"
    pin = JSON.parse((buildpath/"script/kilocode/bun.json").read)
    source = JSON.parse((bun_prefix/"INSTALL_RECEIPT.json").read).fetch("source")
    if Formula["bun"].tap.name != "homebrew/core" || source.fetch("tap") != "homebrew/core" ||
       source.fetch("scm_revision") != pin.fetch("revision")
      odie "Bun must be built by homebrew/core from exactly the source revision in script/kilocode/bun.json"
    end
    if Utils.safe_popen_read(bun, "--print", "Bun.version").strip != pin.fetch("runtime")
      odie "Bun runtime version does not match script/kilocode/bun.json"
    end
    embedded_revision = Utils.safe_popen_read(bun, "--print", "Bun.revision").strip
    odie "Bun embedded revision must be a full Git SHA" unless embedded_revision.match?(/\A[0-9a-f]{40}\z/)
    # Bun getCommit() stamps Homebrew's GITHUB_SHA rather than its source revision in GitHub Actions:
    # https://github.com/oven-sh/bun/blob/38afee6c84fcf48c0edb2466aa4b27d287a59c30/scripts/buildkite.ts#L119-L141
    # Keep the manifest's source pin; only adapt the runtime guard after the exact-source checks above.
    inreplace "packages/opencode/script/build.ts", "Bun.revision !== KiloBun.pin.revision",
              "Bun.revision !== \"#{embedded_revision}\""
    ENV["KILO_VERSION"] = version.to_s
    ENV["KILO_CHANNEL"] = "latest"
    ENV.delete "KILO_RELEASE"
    ENV["MODELS_DEV_API_JSON"] = buildpath/"models-dev-api.json"
    ENV["KILO_SKIP_BUNDLED_BWRAP"] = "1"
    # Use the brewed Bun compiler/runtime rather than downloading an upstream Bun executable.
    # The runtime equality guard compares against that same, checked Cellar executable's metadata.
    inreplace "packages/opencode/script/build.ts", ": await KiloBun.stage(item)", ": process.execPath"

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

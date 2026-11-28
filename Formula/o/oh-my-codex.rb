class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.21.tgz"
  sha256 "278446ab420bc009e0645db8b6caef7e4f1b811d1008228b6474a61611c0fe0f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7206f05af42fbf9c6a724c4cc65956b1e6d2d925136e5ab70f6aa2a272fe46de"
    sha256 cellar: :any, arm64_tahoe:   "e2ce0acabf13561a31234343ff4cfdac85a39f32e7f33a1fae88b790914858ce"
    sha256 cellar: :any, arm64_sequoia: "91c65dbf50ca0f986e4dc87a9693572ae6393af58444c745f28aa3c22e681551"
    sha256 cellar: :any, arm64_linux:   "bfae565364237fe3b695e1c2621b9444e78206f817dad9b37bb8624ae3c09d00"
    sha256 cellar: :any, x86_64_linux:  "efd26965693023b833c077af82b51f8e8c23898dc07fa6366183d45455399794"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    # The 0.22.12 release still pins its workspace crates to 0.22.11-dev.
    # https://github.com/Yeachan-Heo/oh-my-codex/pull/4109
    if version.to_s == "0.22.12"
      inreplace "Cargo.lock", 'version = "0.22.11-dev"', 'version = "0.22.12"'
    end

    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    # State mutations require the native runtime; build it instead of hydrating a prebuilt download.
    system "cargo", "install", *std_cargo_args(path: "crates/omx-runtime", root: libexec/"runtime")

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"
    %w[bare-buffer bare-fs bare-path bare-url].each do |mod|
      prebuild_dir = libexec/"lib/node_modules/oh-my-codex/node_modules/#{mod}/prebuilds"
      prebuild_dir.each_child { |dir| rm_r(dir) if dir.basename.to_s != native }
    end

    (bin/"omx").write_env_script libexec/"bin/omx", OMX_RUNTIME_BINARY: libexec/"runtime/bin/omx-runtime"
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    input = JSON.generate(mode: "ultrawork", active: true, current_phase: "executing", fixture: "homebrew")
    result = JSON.parse(shell_output("#{bin}/omx state write --input #{input.shellescape} --json"))
    assert_equal true, result.fetch("success")
    state = JSON.parse(shell_output("#{bin}/omx state read --mode ultrawork --json"))
    assert_equal "homebrew", state.fetch("fixture")
    assert_equal true, state.fetch("active")
    cleared = JSON.parse(shell_output("#{bin}/omx state clear --mode ultrawork --json"))
    assert_equal true, cleared.fetch("cleared")

    require "open3"

    path = [formula_opt_bin("node"), "/usr/bin", "/bin"].join(File::PATH_SEPARATOR)
    output, status = Open3.capture2e({ "PATH" => path }, bin/"omx", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "failed to launch codex", output
  end
end

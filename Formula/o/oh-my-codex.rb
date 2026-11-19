class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.11.tgz"
  sha256 "d9ddf1b56f963211bb721a441886a6d78adc040854b18b08df3f9f3809649a94"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "254f54726e6ec63cac9e32f12f806757ac060050a6120361f91f2d9c38923b98"
    sha256 cellar: :any, arm64_sequoia: "349e0a5f92e07ba7971342ce47cd3142fdd562bac45f8ac04e28941dc8f83b65"
    sha256 cellar: :any, arm64_linux:   "6d1a736636e785189fa0824c2a9a16353d8a962f0db817b8ee4c3b161de7d331"
    sha256 cellar: :any, x86_64_linux:  "cee37c89e382e1bc1ab2d2fa51da15ca6f33c6ced91702ba9d3c8dd8861adb1a"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access!

  def fetch
    # The 0.22.11 release left the workspace crates at 0.22.11-dev in Cargo.lock.
    # https://github.com/Yeachan-Heo/oh-my-codex/pull/4109
    if version.to_s == "0.22.11"
      inreplace "Cargo.lock", 'version = "0.22.11-dev"', 'version = "0.22.11"'
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

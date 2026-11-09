class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.2.tgz"
  sha256 "a7c4d2071e398da565d24e5353333ab508ce8094eac76bc20022c8ab70b496af"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "692968152396ab806c528db83daccd0218f966c8ea16906f8104379037d5a985"
    sha256 cellar: :any, arm64_sequoia: "9c82c8cbf95b3689efc9d711dc5e35628090f5aeaf18d437aabbc8caac784627"
    sha256 cellar: :any, arm64_linux:   "382c0368900f6dddc473885be57c313ad32839ac4d9fb4ce198243f3121b324e"
    sha256 cellar: :any, x86_64_linux:  "28fced36d4831db570d3f4863391ca25a007e5a60992b2e11361c03a074d4ab6"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access!

  def fetch
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

class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.11.tgz"
  sha256 "d9ddf1b56f963211bb721a441886a6d78adc040854b18b08df3f9f3809649a94"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9f1b9d668f69b28527126dc18fdfbf9620f84d8855f89d0c1c5f67e98d8d6eea"
    sha256 cellar: :any, arm64_tahoe:   "85cb14b8076b9a4b4e3db06faa994d1a139158a828dda62b43e8a9ffe112d40b"
    sha256 cellar: :any, arm64_sequoia: "76e9b25038c71be20074c107df84a5c2fe9e61a838817187c82c612f5748e1ee"
    sha256 cellar: :any, arm64_linux:   "98f324a36b56379793cec1078972c427d27fa6df1936c618a61be0010baf23c1"
    sha256 cellar: :any, x86_64_linux:  "73c43b40e3c511ecece7ea1954b8657ebb2bc20ddab3794f8504932e385db643"
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

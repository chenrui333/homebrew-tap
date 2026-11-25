class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.19.tgz"
  sha256 "1aa80c4a62173b4f23de8d09f95219334ba32c296caeaa9f5c0cda90d00146ef"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "73de7ce8abb0011874fae96f908d1d0fffeb16cf24342ba306992385de341969"
    sha256 cellar: :any, arm64_tahoe:   "35f50d9bccb6d009943cbab220ab3a5ec668985fe1557bdabd7b0ecf0d422954"
    sha256 cellar: :any, arm64_sequoia: "87c5b0b72835df445dab67dcd68154a5fc618f6dc26d3c48cc72ea03303d8e61"
    sha256 cellar: :any, arm64_linux:   "76de26ab14360e241f6c7d5501be852e44382c0475785301bda699367a3f6df2"
    sha256 cellar: :any, x86_64_linux:  "0795100510cbdc16537fba2a1cf56e2e2d0d61e44b76a46b1d2b2d19e6c8e6c2"
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

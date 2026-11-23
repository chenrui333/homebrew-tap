class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.22.15.tgz"
  sha256 "496e63429e64a5d494ed7091afb9ffeadc770152f88a5e5cbe2de0c464fa888f"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "569d79dfa712b1b790a1a2344c233f73a25d23be36d3a393c7c65eac01f74b40"
    sha256 cellar: :any, arm64_tahoe:   "d2c4165aed21b17f6cb1d246dfa47fd9460cf843d0ddf18fe35f5d5406f3d59d"
    sha256 cellar: :any, arm64_sequoia: "2c3ca6310b077050af1afbea60b16e6776f3420de9848ddb4719bb3d2189a59a"
    sha256 cellar: :any, arm64_linux:   "dd6b9e73d2ad017677ed5507e41d21fa50bbded682bd3987a32093520b754fbf"
    sha256 cellar: :any, x86_64_linux:  "5e8cee5efd00d556fa8372b97108708d21ee7738cdace7b3b7137b3b632b9c2d"
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

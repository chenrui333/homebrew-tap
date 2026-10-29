class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.39.tgz"
  sha256 "42b982cfeb5ab6c27798f52df7926f9db757d48a85ae1fa06f215dfb3c19225a"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "749f2939406efc462939bea4217d7174d7e3ceacd249e6c85367b2a5d8ad89be"
    sha256 cellar: :any, arm64_sequoia: "749f2939406efc462939bea4217d7174d7e3ceacd249e6c85367b2a5d8ad89be"
    sha256 cellar: :any, arm64_linux:   "2c644e92889c6a561559583df163a3a272861c2a5dce3f27e4eb57e6d2a86cf2"
    sha256 cellar: :any, x86_64_linux:  "a263aac7211855a17d5be1a27067e26209ad9443184e367ca6447bbcd77fccd5"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}"
    %w[bare-fs bare-path bare-url].each do |mod|
      prebuild_dir = libexec/"lib/node_modules/oh-my-codex/node_modules/#{mod}/prebuilds"
      prebuild_dir.each_child { |dir| rm_r(dir) if dir.basename.to_s != native }
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    pkg = libexec/"lib/node_modules/oh-my-codex/package.json"
    assert_match version.to_s, shell_output("node -p \"require('#{pkg}').version\"").strip

    require "open3"

    path = [formula_opt_bin("node"), "/usr/bin", "/bin"].join(File::PATH_SEPARATOR)
    output, status = Open3.capture2e({ "PATH" => path }, bin/"omx", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "failed to launch codex", output
  end
end

class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.7.tgz"
  sha256 "37acebf3b204c9f107f62b5337d407c6dc96f927bee0a8362bae6ceaac8abbf4"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "3ac3494899d63c32d8d7347a087a406055a45e5fc2e9626d620288971f27fa0a"
    sha256 cellar: :any, arm64_sequoia: "3ac3494899d63c32d8d7347a087a406055a45e5fc2e9626d620288971f27fa0a"
    sha256 cellar: :any, arm64_linux:   "7fba5e661662135cabc609ebaad8155e1df8e14b31e350912ffc99dd506b49e7"
    sha256 cellar: :any, x86_64_linux:  "a55fc7d4015b86115e4bed98ee17b78a91bb381754639333329f06f78af91799"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

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

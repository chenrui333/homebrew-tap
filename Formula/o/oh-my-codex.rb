class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.0.tgz"
  sha256 "eaa3a69456ef7f01d18c688f18d0347604501ad49abdaf5df2854a301935b9f6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "3da17630b231287771fb4b8e37aa5bd0d15cca7a9c6d5a18d6677583f0243731"
    sha256 cellar: :any, arm64_sequoia: "3da17630b231287771fb4b8e37aa5bd0d15cca7a9c6d5a18d6677583f0243731"
    sha256 cellar: :any, arm64_sonoma:  "3da17630b231287771fb4b8e37aa5bd0d15cca7a9c6d5a18d6677583f0243731"
    sha256 cellar: :any, arm64_linux:   "c9642bb09f909a2ec8c6c274c197797f0f475a8c9f330a33a9fee1c2ca6202d3"
    sha256 cellar: :any, x86_64_linux:  "773a63d8c9b3f333000e0c6d92a7bedc7a914aac9701ebf299c0c43e0f5841a5"
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

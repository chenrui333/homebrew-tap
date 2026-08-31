class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.21.0.tgz"
  sha256 "eaa3a69456ef7f01d18c688f18d0347604501ad49abdaf5df2854a301935b9f6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1442cf0dcbabe29b12b0d27b74e40e3052fe1fea72ae04589efcc73465a9caa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3199f9742a7acac290cd53310506224e2e59d15bfde4fd749f27efaa3037f060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3199f9742a7acac290cd53310506224e2e59d15bfde4fd749f27efaa3037f060"
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

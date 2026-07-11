class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.20.0.tgz"
  sha256 "28927a74b4c7747bdd94e209164a066fb37780b08cc2ba4c1d1578c9ab6e0df6"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "256344df8eedb4075cb0ada2e3acaca4077d3fe270a64f0a738f362615b158c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "256344df8eedb4075cb0ada2e3acaca4077d3fe270a64f0a738f362615b158c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256344df8eedb4075cb0ada2e3acaca4077d3fe270a64f0a738f362615b158c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c22c86531b094683eb6f6c9cb59e9f06417dc9f5f95272faac3fa93266dad0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c22c86531b094683eb6f6c9cb59e9f06417dc9f5f95272faac3fa93266dad0ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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

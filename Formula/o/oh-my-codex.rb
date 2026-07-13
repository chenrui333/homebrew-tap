class OhMyCodex < Formula
  desc "Multi-agent orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.20.1.tgz"
  sha256 "628333b2e2e6e2352ea8e329a5732bc4be02b5fa63c2a94a67b8b8f8985ad406"
  license "MIT"
  head "https://github.com/Yeachan-Heo/oh-my-codex.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d08580d3761d1dbb44c62391b7910bd70fc1c1286c99720a297ac5a119f967d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d08580d3761d1dbb44c62391b7910bd70fc1c1286c99720a297ac5a119f967d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d08580d3761d1dbb44c62391b7910bd70fc1c1286c99720a297ac5a119f967d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd794dd85cc7b02cf75771eb00131b0a627d85080d45ccf1be3733d658c6607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd794dd85cc7b02cf75771eb00131b0a627d85080d45ccf1be3733d658c6607"
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

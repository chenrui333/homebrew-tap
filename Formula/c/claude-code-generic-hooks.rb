class ClaudeCodeGenericHooks < Formula
  desc "Generic hooks for Claude Code"
  homepage "https://github.com/possibilities/claude-code-generic-hooks"
  url "https://registry.npmjs.org/claude-code-generic-hooks/-/claude-code-generic-hooks-0.1.13.tgz"
  sha256 "f0b9d95daab6c4be59fdfb6ff55ede58cd816f07e22ca0e8e8d5ae152341bec6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac31a2b286f4fe1a6e1a38747f3beb8cd43873a5bc928bec4726dee0986bb67e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaccfa1b779e6e67e1d2619608a98ec7a37aad89aeb1109eb41e5970f76440ce"
    sha256 cellar: :any_skip_relocation, ventura:       "4b693d696e5885aaf2628232d5138a909a5faa8cb274ab64ae32ceb36761a749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b9b59ca12a85f15605362d6e82c972118e41f08597f756afa273384abdbd9c"
  end

  depends_on "node"

  def install
    # patch version
    inreplace "dist/cli.js", "0.1.12", version.to_s

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-code-generic-hooks --version")

    output = shell_output("#{bin}/claude-code-generic-hooks activity 2>&1", 1)
    assert_match "Track activity start and stop events", output
  end
end

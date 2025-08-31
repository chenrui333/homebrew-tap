class ClaudeHooks < Formula
  desc "Hook system for Claude Code"
  homepage "https://github.com/johnlindquist/claude-hooks"
  url "https://registry.npmjs.org/claude-hooks/-/claude-hooks-2.4.0.tgz"
  sha256 "b55f6dbdec8ec51f26f459bf2888ae9cd6deae1a1e3ac992904080e118b6e80b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983448ce26102e9d3255b8eb7105fe877cc8e6b85b4be89257859b68f34196be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dc541818456377ada97124cc91cd89460a80bc9ac7adb155c9d5c984957e8ad"
    sha256 cellar: :any_skip_relocation, ventura:       "d906ca96dc992dcaefabf550d91158fda7ea04e4c913d267ddcbe5a8cf1699ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331f2b3fcad10c7a811966b0356edd4f02fb699b209ce3911fa2fd2e1d83dc58"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude-hooks --version")

    output = shell_output("#{bin}/claude-hooks init 2>&1", 1)
    assert_match "Claude Hooks Setup", output
  end
end

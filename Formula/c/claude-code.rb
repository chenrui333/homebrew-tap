class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.56.tgz"
  sha256 "96ff0e446dc662afae8f1131f880c8ecd57263aabd0b04fa422387e2f9f5bf04"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fa3dd5b879607323b2e806455d1e787406974a38ffb394abbd5f04f6f5971106"
    sha256 cellar: :any,                 arm64_sequoia: "609c24e1d767e337a788cf0efa6dbbe79ec720b7e57e1a80796f49221a863fed"
    sha256 cellar: :any,                 arm64_sonoma:  "609c24e1d767e337a788cf0efa6dbbe79ec720b7e57e1a80796f49221a863fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58bb16cb5fae87c17cf737a7a201a10a037aaf10f09421e0129cdce17bc983f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13656143035763c47f5680ce86b8f5990b236d8ffd90f2384cebadc738db44fe"
  end

  depends_on "node"
  depends_on "pcre2"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built libraries
    # https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md?plain=1#L79 (since 1.0.84)
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_vendor_dir = libexec/"lib/node_modules/@anthropic-ai/claude-code/vendor/ripgrep"
    ripgrep_vendor_dir.children
                      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claude --version")

    output = shell_output("#{bin}/claude config list", 1)
    assert_match "Invalid API key · Please run /login", output
  end
end

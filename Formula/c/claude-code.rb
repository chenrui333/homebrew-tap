class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.55.tgz"
  sha256 "5caf81de81ab727022d7d6bb4ed82fd99a71d3e33f9c341e9e11d05844ae9991"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6aa396b5a0f85988fffc194630240fc813fe539d057248fedd8f90cae65b9d74"
    sha256 cellar: :any,                 arm64_sequoia: "ce5c98016b5160154333ec1f5a230f41c3673d4ead3a3c50cadc8b83d859e0e5"
    sha256 cellar: :any,                 arm64_sonoma:  "ce5c98016b5160154333ec1f5a230f41c3673d4ead3a3c50cadc8b83d859e0e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cf5a872807d060a36e280957ed1535c8519d038a5a0fbbbf9ab335950cab913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e714e5572060b995e1571de3fca0406b022667d6865c90c84d619d7bf0b9ccb9"
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

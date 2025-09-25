class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.124.tgz"
  sha256 "19e11a534aa6a902a0eee158d7dfb41e03a11c8c6290d86e695ca9ee96e8933f"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "3b24058edf724749196a1526743f450c392c5aa06982eebb0169307e81bdfeef"
    sha256 cellar: :any,                 arm64_sonoma:  "e5636af8bf2cd173edd6e61e048521d6ccf405ffb85bfc2cf43514d7823896ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1b4067f63cd3b7ad3b02e3793b4b9c659b200772179c6a0a63f06dbe71781c"
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

    output = shell_output("#{bin}/claude config list")
    assert_equal false, JSON.parse(output)["hasTrustDialogAccepted"]
  end
end

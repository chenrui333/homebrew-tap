class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.51.tgz"
  sha256 "87b8bb93459d5a13201618388b6753b1833fbbde1a65171a24d0af25f27b002e"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2caaf61adce852e5a899a682e16547d91c7f23996f4ecc22c06303ee6cfc1fb1"
    sha256 cellar: :any,                 arm64_sequoia: "10d5ecc3c74c3e68da30827c476bcf656adf978022f73947cd8c96c03daf3a55"
    sha256 cellar: :any,                 arm64_sonoma:  "10d5ecc3c74c3e68da30827c476bcf656adf978022f73947cd8c96c03daf3a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d84c930c46730b063740727696bfde5c07f5f3052474ca86f88dd1178adfedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a241e2b9193f948326c4cff7eca5710f82f3ce1bd6a0d582cfdc792562201e6"
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

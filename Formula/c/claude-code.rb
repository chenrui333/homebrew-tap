class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.32.tgz"
  sha256 "f0a95b505a73d00c075d1b0845a8d77a0bee5d56659d3b28a1db06c5cce42643"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "4c08758ab3b23de984f10cb66bf3813b328df7a7f8bd384aa96386bc1674d592"
    sha256 cellar: :any,                 arm64_sequoia: "e098fd830e30835b48959746a6e67a2482d56989582865ee2c2ed42d528a098b"
    sha256 cellar: :any,                 arm64_sonoma:  "e098fd830e30835b48959746a6e67a2482d56989582865ee2c2ed42d528a098b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38208132e4dfe926e50976e45f33287fb75b6bb176595a56505a3caffc9001a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea99f7b4aaa3ef00ffb137784b4b0802f2ba236397663fc9c5f2165b2cb02bb"
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

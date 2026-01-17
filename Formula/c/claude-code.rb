class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.12.tgz"
  sha256 "96d284fbe36f80606b4fd5df962297c9cf8d79ec1d9a74aa8d16df93bb7f0685"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "fdfa12e2c322ac9ea9f84c49d90a5ef848e745856c092eda5a5b7c4b031909df"
    sha256 cellar: :any,                 arm64_sequoia: "dda0f63e86f8e0ac949c814b452cc51253708d821970a8317c2f8a1555ed8cac"
    sha256 cellar: :any,                 arm64_sonoma:  "dda0f63e86f8e0ac949c814b452cc51253708d821970a8317c2f8a1555ed8cac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b61e573246240e7428a400aaf30f5c05aeb88e3342c8b68e2719521671da3c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1bd90f22202846130c2f1a46a7d9a95a84d5ff47ac9a847d7732853fd194eed"
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

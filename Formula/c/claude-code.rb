class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.73.tgz"
  sha256 "76c19935a9f88ac0e09b88fccef7488ce1d09fd3898fc357aaf2915cff7a8130"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3adafb103ae03703adc02852732814c96a9f2e5597dbbab358419b1c5683f654"
    sha256 cellar: :any,                 arm64_sequoia: "708d9a1c9d117b9f296b09227896a7c30309ebff817e6548f2a742053299a0a3"
    sha256 cellar: :any,                 arm64_sonoma:  "708d9a1c9d117b9f296b09227896a7c30309ebff817e6548f2a742053299a0a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9441405afe81c8bfef9bdf95f23bd4e640d7585ca5241254de6e53efa8b2aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b773083ef978413437ba52e56c8aa74b72d358568944f5b49275770397217f90"
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

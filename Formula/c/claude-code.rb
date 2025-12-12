class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.67.tgz"
  sha256 "1f04fd61fa17e386f5f12af555d5cca345fb9c806b6a2d400063db57d974ceff"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2d168e74eb64e5f3f4b6b341fa8e1f958a4b9f7e421af06dc8f6ca007121352a"
    sha256 cellar: :any,                 arm64_sequoia: "c90e051dbe9c0f9172fd1b6f00ae91100e8ad6150f4864ae39b8539cfff44ee6"
    sha256 cellar: :any,                 arm64_sonoma:  "c90e051dbe9c0f9172fd1b6f00ae91100e8ad6150f4864ae39b8539cfff44ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14107b875801433e2e52cce3cc2080495d3d6dfcc65a0308381f92cfb71e0fde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4b4888ef58f5a578c2087820aceff5da95f931876f5ade19ebc3a7dd1e9472"
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

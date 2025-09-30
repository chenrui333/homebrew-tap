class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.1.tgz"
  sha256 "126c7d752fc6ee24f08c2db6fa70dcf4596833f48d8bde5a1f0d8d2f149ce023"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "61b2703036242cf2100ec081db810c21188439898a53dea872a9f3f2810e267d"
    sha256 cellar: :any,                 arm64_sonoma:  "8b87f4ab35cbe4f08ddb72f5e688448a5bced8e41ce2ca93815dac91600accf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9318446222551600b37a6fdf0e7dc513709280cea6418de8e116d27e5bd0f57"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.6.tgz"
  sha256 "67c54ba518c2bea570ddb95e2206a6a436be7ad610f9024860baed671623fc7e"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "dd3e0fda9b8cc7e44e5df17a150474bfcee30581c1db135c6cf5773a9fb6c807"
    sha256 cellar: :any,                 arm64_sequoia: "6e380e5df1b442eab7b9be9cb0d0a40cd95ee58483be7d6878a43e17e6d322fe"
    sha256 cellar: :any,                 arm64_sonoma:  "6e380e5df1b442eab7b9be9cb0d0a40cd95ee58483be7d6878a43e17e6d322fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7369316a2b31691dd8e9f3e9c61c722d69bed25852990abc8ea8495f5dad1271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc26fa585a10725b88c29683d38c2bd480de2e291f2487937f5e4e05f86299cf"
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

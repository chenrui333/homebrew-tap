class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.115.tgz"
  sha256 "39b7bccd6f59f275ef81e786ea7a474d28a6a36cd8d805cbf9f11dcc1ce3aaa6"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "4cecd2422e48258e5870507911a854432c463439a3c97f2c9009933e1acc9e1c"
    sha256 cellar: :any,                 arm64_sonoma:  "7c7ee9e658783a3df2f5bdb0a92cf374fc5a4d54213dfdde84f001185dcef74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a468b1f4bba90356e198e5711526232247970251c3e8771fc2bee1fbf3a192e1"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.11.tgz"
  sha256 "931342924784d36b965929aba8e90941174204cda2fa06d74d1b22030eb1e205"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "e1c614a028292156d239e4b6bbe396b9ef9be4ff39d2edb75982e11527291ec0"
    sha256 cellar: :any,                 arm64_sequoia: "658547b5ccd5256ac594c501e59aa1e11e2638aab308564cde884eb450808e5b"
    sha256 cellar: :any,                 arm64_sonoma:  "896b1c94111c9338999ccdd758a3e766ff4bf55c00a96909973131ccb9e1c56b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f9ccf4bc8c09f3f1927c3f010c75fe8154a9c273490afc3bdc1aa275c1180f"
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

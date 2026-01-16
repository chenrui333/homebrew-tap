class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.9.tgz"
  sha256 "ddf4780d1063fc4fab4acc3e1f0116e9d3d01bc24a06eeb6859ced468c167950"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6c3be5f712914f4ff876465ff2553fd5c845bc58d5820fcefb1528bc50000d35"
    sha256 cellar: :any,                 arm64_sequoia: "66dc3c232f77bd2ea8ea6f5e8de05797178c92c3ea593d1a2f6be079efc0f9d1"
    sha256 cellar: :any,                 arm64_sonoma:  "66dc3c232f77bd2ea8ea6f5e8de05797178c92c3ea593d1a2f6be079efc0f9d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a163a45d992ff4b140e9fa851a69d6dbf6eda789fb246d2985351087872f9cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439d390d41c72cf00a9706ca419f3bde48db48e74b1d78b762fe93df6d5502bb"
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

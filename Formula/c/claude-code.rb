class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.73.tgz"
  sha256 "76c19935a9f88ac0e09b88fccef7488ce1d09fd3898fc357aaf2915cff7a8130"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ef6f58375c10b49ebbea80b6ffb952437645539d53626d3f294df79884ec5d02"
    sha256 cellar: :any,                 arm64_sequoia: "bc7d9210550712cfa08014ad4894b0f1f9b5b260653240bb0a68d38f2a59475e"
    sha256 cellar: :any,                 arm64_sonoma:  "bc7d9210550712cfa08014ad4894b0f1f9b5b260653240bb0a68d38f2a59475e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fd0b00141b987212b732c39b0a0d935c1fe695a769bab24fafe3485290e663a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c84181e84d2da45dc9c4cc0aad7b98b8dd5385aaf49f734f23953fdf0be263"
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

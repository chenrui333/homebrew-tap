class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.11.tgz"
  sha256 "931342924784d36b965929aba8e90941174204cda2fa06d74d1b22030eb1e205"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1bc06712906ca12a8fda3a895d86f8667801eb2ce9e5247d0ce82d5c7e7a740d"
    sha256 cellar: :any,                 arm64_sequoia: "1419ee7b3ba9986adb8b2604406c6e2e8bfec9bb2c40250b7b01765766557b84"
    sha256 cellar: :any,                 arm64_sonoma:  "1419ee7b3ba9986adb8b2604406c6e2e8bfec9bb2c40250b7b01765766557b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0896ba1edda3973ac47ec22ecb5f9cc49e302c66cf8479d40a048150cbfa28bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad1272c92340ef8ac68880f34c060c18f0b76b2abceb15f46ca5b7735de69f81"
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

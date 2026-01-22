class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.17.tgz"
  sha256 "4ee835db67604ff4e94de129050c77f0ef78f02c4b7f9f5539fb0317e0dd7bac"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "05a9f8d0159f5393b21814199efad81c6647e5f8d32d4db9ee12f7d6955e66a1"
    sha256 cellar: :any,                 arm64_sequoia: "e8e3422d3fd6a37f2a4264d72e5322d784eda08951fa69484f9f708524b9aaf6"
    sha256 cellar: :any,                 arm64_sonoma:  "e8e3422d3fd6a37f2a4264d72e5322d784eda08951fa69484f9f708524b9aaf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f25854f1e52dc1d7d4114e7848f0996f697fca2df9163cad724c0fbcff43790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0167c8f70f729607c6d5de4127411a65fc9ae01d85d9c0343f2d9c8d73c864e"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.36.tgz"
  sha256 "42095aacc8e39d8b7d5c0162fb44d873a1cc39430681269bac492c004cfd0e13"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6277e0bcedb24627433ffb0ff740f7352f6cf9051c8e8af3ec67b45a0e4b7fe1"
    sha256 cellar: :any,                 arm64_sequoia: "72f40cda33ea3ae697c71f7b8cec93377251b9b1fe4582fdd5ec804c0f3c9ae7"
    sha256 cellar: :any,                 arm64_sonoma:  "72f40cda33ea3ae697c71f7b8cec93377251b9b1fe4582fdd5ec804c0f3c9ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fceb78094b801a9e8d56b2ccbc6b7aef23533d144d4aeaf7a86583e25591bad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88af5da2e03a668712d77f82b6f3de4d234d658426a8925448e555e5c984be92"
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

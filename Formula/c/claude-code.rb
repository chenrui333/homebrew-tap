class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.41.tgz"
  sha256 "7d3ed8c9eab76a20a97c04368fdc76c9192b2626b48de38b37a847052c7c4317"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2bf9f0a1f3935d60d123bedb0b51478ee281d77d51e4a73bde2334539a3e11d6"
    sha256 cellar: :any,                 arm64_sequoia: "c1e30d6873aadaef373515ba0bad5f9cd2b4d415ff31377f60114a3c6acd3282"
    sha256 cellar: :any,                 arm64_sonoma:  "c1e30d6873aadaef373515ba0bad5f9cd2b4d415ff31377f60114a3c6acd3282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee7cf7a263c6e0c9bb9756e72670dc7d5d1d0e2a5e0bd281c33423b5bc48b9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b523e5c79e27b7827dd2f53b116a16df8bf19e092964c552636757c29d26ac8"
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

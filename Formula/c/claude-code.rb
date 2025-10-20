class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.23.tgz"
  sha256 "be541f9be6ce0b2358791b28721e90dca4c3203e485ff09259d2e92142a7686c"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8c2c2fec0383b57e904a322f24ff32d2c25eaca95934e022a08efef12e510a81"
    sha256 cellar: :any,                 arm64_sequoia: "dcc26e4aedfe61313e0e48cd2d1741019a6176a6166dc6f83a5df0e93fef1ea3"
    sha256 cellar: :any,                 arm64_sonoma:  "dcc26e4aedfe61313e0e48cd2d1741019a6176a6166dc6f83a5df0e93fef1ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52ea554921a0155329b81bd6adfebc0720391eab2891cfed828887c7d1f149fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e14faa819f95624f89aed2d2eacb03a75f853a7711017e0c0a2547e24bbf90"
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

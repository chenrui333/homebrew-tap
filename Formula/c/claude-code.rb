class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.2.tgz"
  sha256 "c82450b4adbce8438656cfb448ca24013a6fc027990b88ab5756e6854d248222"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c0d7ca65c800568ad56b40106fa2a9843840dd6f6b472d32236a3485e5ce31c0"
    sha256 cellar: :any,                 arm64_sequoia: "31a0730c4c0207679d1fb8e26e7a241dbabc2f546f3f0af4b2bf5104ca214cff"
    sha256 cellar: :any,                 arm64_sonoma:  "31a0730c4c0207679d1fb8e26e7a241dbabc2f546f3f0af4b2bf5104ca214cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a4bfeab8422209240d2845cc8e3192f08f01ac38556b16e687016762ac4ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fd152130f75e94b39758d168b621dd2ee6f1fdcb3ba4f1ecf289a579933ea1d"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.70.tgz"
  sha256 "70dd72b6295bea8e885050371fb965ca89ee860b252c7c7edfd971ed54c9f151"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7d1909548fada1bdac6f1fa6fb3f37997729e88351ecc9b558dcba447fd73f30"
    sha256 cellar: :any,                 arm64_sequoia: "3d614149c9402085a238a5178fe028656615c445f5e73dc67ad4365809e92fd1"
    sha256 cellar: :any,                 arm64_sonoma:  "3d614149c9402085a238a5178fe028656615c445f5e73dc67ad4365809e92fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f46e2c6988cbf225e6f7f76c23d8f7615183c526987229cd0fb2c5b5a3853e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f807c647511b30feb599794b3d9e04d870ba774b3ee763fc8361593244de57fd"
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

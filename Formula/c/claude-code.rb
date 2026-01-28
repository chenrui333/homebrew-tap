class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.21.tgz"
  sha256 "628e58e757fdec37b6835cefb6cdaa31118bb4e2b630d7f0de2d72b0a4a627d3"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2d614608ddc1478e7503fbc33f9403d278dd6837bf61962564064fa2cc57305c"
    sha256 cellar: :any,                 arm64_sequoia: "b1f88d63e6c325f401828bbbf590c2e4de6064b0f0a9b0c7048db4b113dd1adb"
    sha256 cellar: :any,                 arm64_sonoma:  "b1f88d63e6c325f401828bbbf590c2e4de6064b0f0a9b0c7048db4b113dd1adb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294af14851524edd98beb0b086052073a66515c770c9e09fecf4faca5ee5d14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fbce51473d27cc93a19435138221682ac91a37dc496f0552e6b203bfba573b3"
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

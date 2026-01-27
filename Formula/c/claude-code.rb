class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.20.tgz"
  sha256 "de3c729f242dc8fd3f32dfa434ca28e3b62806996a24b62f482de702f46ef049"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "53f146a1838fe203368bfc32eed8756814e96ff44184f97e3d3f87f809342d18"
    sha256 cellar: :any,                 arm64_sequoia: "e29310d0e760d3b830194d5315bc93db5a04e74f036330d064cce13d59dc9643"
    sha256 cellar: :any,                 arm64_sonoma:  "e29310d0e760d3b830194d5315bc93db5a04e74f036330d064cce13d59dc9643"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98010e2eacc63fe53c7a19c3fdd275988e7be77e4791d490033f000f78410159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb2e08d077476f4a24a651a3baedd3ce6f8760f52a64f2f0b18480d3500638ed"
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

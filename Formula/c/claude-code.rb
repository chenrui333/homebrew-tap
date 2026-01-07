class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.1.tgz"
  sha256 "a0c9a2bd1a53c304403ff9be039ce7894ecf81678bb0faff678dbb551b4016eb"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8519f89cd7851240f0b7760ae03411e5b480626bc235f06cd0db586fbe139173"
    sha256 cellar: :any,                 arm64_sequoia: "c6556e3c58a138fc90aa07389798f40b2f60dd1753766ae89da26986e5c10365"
    sha256 cellar: :any,                 arm64_sonoma:  "c6556e3c58a138fc90aa07389798f40b2f60dd1753766ae89da26986e5c10365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e55b09676cda43020af2ebdb0ecfafdece70c02b077ce292f4ca5d370d5a80b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eaeaeecbb27ff658122132d26e876806f33cf1ebd712df06cd92da42ea16249"
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

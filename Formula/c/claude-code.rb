class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.5.tgz"
  sha256 "a4958690ab469fc0c832e1dcf8bc614b4b5ae27c6b67228939dd2a5df00ced52"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "eacbc9cda145794e9a141a73372f792b906138b601fac839ad6df4af087a5716"
    sha256 cellar: :any,                 arm64_sequoia: "cbd3805ef9f5255149ec1927ff57fbad06c5ab867dc2540455b7a7061e8c8c75"
    sha256 cellar: :any,                 arm64_sonoma:  "cbd3805ef9f5255149ec1927ff57fbad06c5ab867dc2540455b7a7061e8c8c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53cc3deb904f7b75112687b983778233e97ebaf642ebe7e1b0c16748844c542c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c600f823604a154c6441da9e186fd3497bb1647f23191aadcba5c81d773be50b"
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

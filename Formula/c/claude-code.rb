class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.4.tgz"
  sha256 "8111c3f4abd58cff2f4e77f08f5a326919bb65b2026a9885fb9dffa2cd8bd771"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2c5b7098dd4c581ae2ca3d23f73472d596f6144650dd2a79aa02a32c0a7c83b5"
    sha256 cellar: :any,                 arm64_sequoia: "3f9a2fd6d803b1e1993c27677ead583468f1a8fbefc8db15faa115bb0e56f2c8"
    sha256 cellar: :any,                 arm64_sonoma:  "3f9a2fd6d803b1e1993c27677ead583468f1a8fbefc8db15faa115bb0e56f2c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a18fa4d1dba7e3ee288a398f4b5793a0898e4feade4234524d6641df69710229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87620f68e110d06a28d6bb71a035e5b93c93668ad17fd54b13a3d7f1943655d"
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

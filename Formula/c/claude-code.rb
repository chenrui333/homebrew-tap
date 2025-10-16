class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.19.tgz"
  sha256 "01256799bad142e5c95844133a4add36eadf320d15c445fcf0ededfd69ea5ceb"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "c141f3c279fe35ea7ab57db4380de39e24b07d7220fa8301a04c10fb3b619869"
    sha256 cellar: :any,                 arm64_sequoia: "2df164c09a60e4730ed6abf3345bfd8378a54ff13ed6f77c97ee52058b6d1d7b"
    sha256 cellar: :any,                 arm64_sonoma:  "2df164c09a60e4730ed6abf3345bfd8378a54ff13ed6f77c97ee52058b6d1d7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb44d943a274267e76c7a0e8145f5c2b36bcc1da0a87b438fb9039ac5719e161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8002507765301ac8d0b04c606c5ebfa8068072738c371593dbee7de205f3a83"
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

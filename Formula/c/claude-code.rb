class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.5.tgz"
  sha256 "a4958690ab469fc0c832e1dcf8bc614b4b5ae27c6b67228939dd2a5df00ced52"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "50e3f3ebdf2a551c5fa7e9d7251b65bf2e0d25d17d21138e97a57216a0b691e1"
    sha256 cellar: :any,                 arm64_sequoia: "dded59442b4611167c5068119843d98fbd9092a3f2f1bee61680ad851e085182"
    sha256 cellar: :any,                 arm64_sonoma:  "dded59442b4611167c5068119843d98fbd9092a3f2f1bee61680ad851e085182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec1ff282c891dd795f8af46cbc715097404fd8338760dc24418f94d4dd5c6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85917ed27197732a50dc985e95ca81a3ce015b21621cd7bb4383cd4db92d0078"
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

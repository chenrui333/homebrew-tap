class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.8.tgz"
  sha256 "ffd80572c057745dacc3c1dd23cfe1dd0517d0c133acbeb31ff213fb5496ed8a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f110d18135ae7ff1fbfba93c3ab2c2bc2aadf288150e91c7f7e82b174ba97cfb"
    sha256 cellar: :any,                 arm64_sonoma:  "684c8b231b01c446c856aa371f3ee13751418b163a887b2e798d7a5eee15f6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1308c413702274de9c8378cbc86ccfc92b3a3b5a387dc269b346507efc85b1a"
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

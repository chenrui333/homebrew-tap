class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.60.tgz"
  sha256 "1a84fa97138386890ea9aa32ed03ffa537557502310c8f7bf1d33d182bda7914"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a6e27c03b545e0c4040f728d63de6c0d32b4bc219db3be9e200644dd13c42695"
    sha256 cellar: :any,                 arm64_sequoia: "651a7f7f1a54ccaabf0b05e8825a50892fea1b5aa6f86db850a5622901d3ffed"
    sha256 cellar: :any,                 arm64_sonoma:  "651a7f7f1a54ccaabf0b05e8825a50892fea1b5aa6f86db850a5622901d3ffed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e969783a3db77c514c5ab609f14288c0cdc73c7e40739d5e663455df1bdd589d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c488dfa3bd5b77dd1296f94755b5e21fca0159e6b8e995c637449377e4673f1"
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

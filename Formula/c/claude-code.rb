class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.0.tgz"
  sha256 "48f68e68d2a7cb10d755605dd463a40012b6cf2a76ce1ae5c1fa4b92e5f51f20"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "65b6dc4150b5b537ec41ec040bf8a3b19f42fc65b5c156924d7aae15c7e137d1"
    sha256 cellar: :any,                 arm64_sequoia: "7bb1cbfd20aeb8d1eb4724e8392eac800b3aec17a47031be6ff86834e4f53d47"
    sha256 cellar: :any,                 arm64_sonoma:  "7bb1cbfd20aeb8d1eb4724e8392eac800b3aec17a47031be6ff86834e4f53d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9280094ef1d00f7a5c4f5257781720bb7d954687c3c1879b1b2ca333083a93de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5898bc694ca36c0c43ae3a0c06e2b99afad7dde004431871866781b7f87f701"
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

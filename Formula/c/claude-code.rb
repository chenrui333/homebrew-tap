class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.43.tgz"
  sha256 "fa0e718825184509aad950a61a05f84c03586061c1c876ba6701edf85540ff4f"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "18d88aa378b237e6347987623b3fe656a5f0e0a246b346ac1a8abd0f63cd6a2b"
    sha256 cellar: :any,                 arm64_sequoia: "bc6d8e4057c775cda4afddb49b024796efd5523bef18548e5bf66eaee8a7198d"
    sha256 cellar: :any,                 arm64_sonoma:  "bc6d8e4057c775cda4afddb49b024796efd5523bef18548e5bf66eaee8a7198d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d964d4d5272c9f190638d829cba51f0d8fcaaca2310c1a072ffd9c81f635b692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b1aa722ce6d1e6eea2125ceac0ca2f9d1db347263ba44be93db852e9ded7832"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.27.tgz"
  sha256 "db32a22b94483061f145ae0eb0182ae5b61d24b5b70c5959405f31b5880db137"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8afd31a45dd49ed7ac70480d8cdb600df42a1b183e563c975ca264b0fc30cdd6"
    sha256 cellar: :any,                 arm64_sequoia: "6994097bd28821ca16abc911a8b7a551fef2faffddd507236859023a4d64dba1"
    sha256 cellar: :any,                 arm64_sonoma:  "6994097bd28821ca16abc911a8b7a551fef2faffddd507236859023a4d64dba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc3c9b82a68c3c239d7813b3199584d2f0e434fea36fa8b58726f81439bcb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f02b2562002d8db84ead8430151cf8d4964b1f5e28cfddbb32827a316a49c01"
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

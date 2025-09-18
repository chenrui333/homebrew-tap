class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.118.tgz"
  sha256 "cc813e6eb417031d45ff47626d81dba4b7b270a74bbb1e4fdec0dd1461473cf6"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "bdc92336ce4c020213c2157cc69c43f7ace93c9d6333c6fe3bcfb190ce8daa1b"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bcfc3b5649667c97bcc183dc214605bf77d44127b607e8d28c6d242fcf3db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26c58a8dc500723745db0d7d20849e1196364ccff75dfe3c23e505919e7c6104"
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

    output = shell_output("#{bin}/claude config list")
    assert_equal false, JSON.parse(output)["hasTrustDialogAccepted"]
  end
end

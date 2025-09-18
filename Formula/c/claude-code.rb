class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.118.tgz"
  sha256 "cc813e6eb417031d45ff47626d81dba4b7b270a74bbb1e4fdec0dd1461473cf6"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f2aab9d2da09c8d60c9a971a3cb98ca8a0fddb49610c996e8e93a430f8df652a"
    sha256 cellar: :any,                 arm64_sonoma:  "a73ee80ba2e3188c7d81cf0da32a9a0d0e339ab47b93d66755c944284d30e31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e95fbd5c3aa7a573f1b46422ac02cb40f35933a8016e29b2203fa3fb93010c"
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

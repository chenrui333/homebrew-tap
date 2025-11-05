class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.33.tgz"
  sha256 "53b8851e61a3bc7f8b39fd8dbaf0e54e6e61f2dc9289fa793742ef0d43d79726"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "57014655f16f236e55673b93400755231f464313f44d864cb3896114dd539b51"
    sha256 cellar: :any,                 arm64_sequoia: "2a3562ab679d6d4d8069cd17d0ae566c71e81acc8ec68d3ee80459c0c3548b13"
    sha256 cellar: :any,                 arm64_sonoma:  "2a3562ab679d6d4d8069cd17d0ae566c71e81acc8ec68d3ee80459c0c3548b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "378e3da9a8e8cd38724f9f6cc51d3c0c7dcf03f6e6acd6b4610a5678e527b9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7581b867f5497d85d964ffdbce4a3e1750bfb27c798ccb107efc78344544bd"
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

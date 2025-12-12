class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.67.tgz"
  sha256 "1f04fd61fa17e386f5f12af555d5cca345fb9c806b6a2d400063db57d974ceff"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ab7773420591ca3bfbb5dbffcfea458856fc8edfccafdbe9afd33b9731cad41d"
    sha256 cellar: :any,                 arm64_sequoia: "79c58960b50e3380a35640bf58b28445449da0a6d711d1235a4e438ac7f1d304"
    sha256 cellar: :any,                 arm64_sonoma:  "79c58960b50e3380a35640bf58b28445449da0a6d711d1235a4e438ac7f1d304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776df6ca9307e0c8b55d7d15dcc569980ce8efe3c5724e982018c392d1512523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53464e9b521209ea9f11ed726c8f3d97214d5d00464d99905620edb9eace7ce0"
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

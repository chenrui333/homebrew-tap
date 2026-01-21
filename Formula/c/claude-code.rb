class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.14.tgz"
  sha256 "7e00d2282adab8e5db80f73e166c055f7468f021b1c16d09922d30673e778298"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5e5067569c273b71bf7045a670fb88b046f26056827a7c38651735845aa68e83"
    sha256 cellar: :any,                 arm64_sequoia: "087cf4bfd93c2a444566b241d43f4069857b270acca512c664bc4ac00389d171"
    sha256 cellar: :any,                 arm64_sonoma:  "087cf4bfd93c2a444566b241d43f4069857b270acca512c664bc4ac00389d171"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd481c97208eb1e4cef5161b54aadae008d68c40a206afdb8ce1a428eaab91ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "350b06bcf1dca1979818748209ca9eeb60337b8d58c47eecfee8a8952063b421"
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

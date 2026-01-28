class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.1.22.tgz"
  sha256 "3aabcb8b00794f065ac43bf237ffbff9eb9e05d58d698c5df3571de4064afe60"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ea306f2c62f1a30a6114e590600dc18566760a9389f64b2f9739ab259c0b1447"
    sha256 cellar: :any,                 arm64_sequoia: "a4d24f69225410584a0a002abc823293a75b99d944d86362cb4dc80e3e1b44b2"
    sha256 cellar: :any,                 arm64_sonoma:  "a4d24f69225410584a0a002abc823293a75b99d944d86362cb4dc80e3e1b44b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb42ebf4d46c1ee0410278f443ea9da33bba2d13a94f39c3400b50d02781b836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c45e8555b9442f663bc7eaa8caa3de6d71bae78b4543ddb9e9ee8c710bc3b5"
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

class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.42.tgz"
  sha256 "ed56cf3bb1020bac9440ba691d27b6e8b94c3905fe352fb94726b3e9c588955a"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "6eb99e496208065234d1f538e18e275ac7acc8156b6fb0cc1c3b6a2886f495a0"
    sha256 cellar: :any,                 arm64_sequoia: "226dbba673f240f35405d2c91f000e6c0a691356b80b10205c0f4143e12260ef"
    sha256 cellar: :any,                 arm64_sonoma:  "226dbba673f240f35405d2c91f000e6c0a691356b80b10205c0f4143e12260ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7706730877e18933577cc2dac7eec35e57d033dc5117353c5f6b5e8f50262555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c931ac9d4208e524c68a17aa594c7dcdda482d6bcb4453c1b68640ff6801f94c"
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

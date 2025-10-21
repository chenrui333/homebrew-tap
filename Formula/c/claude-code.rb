class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.25.tgz"
  sha256 "962eaf1339a34e49b18669d6f6fc5e7bf93a2deefa7686794adb84f5dad3852d"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "396e006b1a1dc61c822b29f0e32a046561d47390ab2df5e204226f5833da8271"
    sha256 cellar: :any,                 arm64_sequoia: "ea8abb6ca9ac87955b72727cb12534543c0d93fecb026593084a4ca1d716d098"
    sha256 cellar: :any,                 arm64_sonoma:  "ea8abb6ca9ac87955b72727cb12534543c0d93fecb026593084a4ca1d716d098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c117ef744b9c9ae7931a27ab11684b8ebaed3339e7b4b9605d77cd0611e06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f351b9f7ba326ffe966760945432f8f17df9347af0ade1b29940f7e06ad0156"
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

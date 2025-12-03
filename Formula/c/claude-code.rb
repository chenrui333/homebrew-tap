class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.58.tgz"
  sha256 "4e43bd644b5eda02c5b12d1e40064adae66c254bdf80be9357e5459c3e981848"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1ab1818c3276f6aa1b36e367a0f9febcaea167c1a48844a67d8536d43f8e611b"
    sha256 cellar: :any,                 arm64_sequoia: "5174e31c01aa1261c85388eeb392343c50622db6fe0a79b9ca6d429b3c6c8f4d"
    sha256 cellar: :any,                 arm64_sonoma:  "5174e31c01aa1261c85388eeb392343c50622db6fe0a79b9ca6d429b3c6c8f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b07885f5b96bfc43c3e6bfaa79f9ce69381d44205f272c4f666f6585c2fac10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652caa7469e11e82fdc5aa1dfd74d12e4dcc490456d30dd1e50c278037eb872e"
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

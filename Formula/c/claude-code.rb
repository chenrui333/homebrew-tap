class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.52.tgz"
  sha256 "f9b8dc55ddbf1b799080591faaa802010f1560d8d4c7dbce368ee1ae5893e259"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "3ba95b38a982fc17048e1f18850480dfa0f2fed59d2c6722e39708e2bf9f2306"
    sha256 cellar: :any,                 arm64_sequoia: "2656245f8005c0d8934eda28d5fc000317f2b1e292aa2808c5947e7dd2354926"
    sha256 cellar: :any,                 arm64_sonoma:  "2656245f8005c0d8934eda28d5fc000317f2b1e292aa2808c5947e7dd2354926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d58ab70299fa13eed96be6b0364ee620b4dde8f22798a5ffe6320f2e7d9b9516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab45db0ece5454064b77c03e2661f2086cd45ac8b2b1452a27ef4f532b723f74"
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

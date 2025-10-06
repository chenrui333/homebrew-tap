class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.9.tgz"
  sha256 "0ca69dfa2d64ae6126eb1abe680f29490d2940aef2904c42902b92419c3ef90c"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "efdf4e36c7c69b017a61b1a65a3528447a3518ad4582413eabbac9ec3d063b2e"
    sha256 cellar: :any,                 arm64_sequoia: "41c560858eab6c3c2ee6d3cc95057d36656eae83521590b3e67a18aa72578aa4"
    sha256 cellar: :any,                 arm64_sonoma:  "be167058a4c06783c9df63afe6a225ab737c20edec8ee72a669279a5d7e25079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "354223eb4777336464fdc29329cb92ed117ba570996ae20e79a5bf940ca77ae8"
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

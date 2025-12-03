class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.57.tgz"
  sha256 "3ff2f935f1e436f0a848ebdaad2776ca0bab0c1e7b941656ce3a6e64d0b74043"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "054c31563aef296a7a4428159690def1e66027409889f937f39332b91385d6e9"
    sha256 cellar: :any,                 arm64_sequoia: "abb0dfa0d34fcb0c98ddc6cfa96523a114e6eecf4681240bb88d236722ab39e5"
    sha256 cellar: :any,                 arm64_sonoma:  "abb0dfa0d34fcb0c98ddc6cfa96523a114e6eecf4681240bb88d236722ab39e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61737e246f45f1b6e4ecc5d0d4af2dc9557e5fe4a1b370cf04a5ec6c4195a487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907df7ae926cb2d8ac060ed20b4f43615a40a001ad2d8543321ed24f0a7bb8f4"
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

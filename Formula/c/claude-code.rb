class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-1.0.119.tgz"
  sha256 "c40a9d18b26b2553c6ca1ad865e9fc88d0926d22daefa8a87718e1427090a7a4"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "832dd7c0bffce8ebe2a973e3ebc760bb787092232e458e3f4bc78ff25c3162ff"
    sha256 cellar: :any,                 arm64_sonoma:  "68231f951af38cab5ee2c41db9ab9192ec3d4546173dd89590dbc1070391f2af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ec3a926cce2d9fe72663479ed9dc0c7e2ac08816d1913f4ce08575d6b7cef2"
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

    output = shell_output("#{bin}/claude config list")
    assert_equal false, JSON.parse(output)["hasTrustDialogAccepted"]
  end
end

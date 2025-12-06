class ClaudeCode < Formula
  desc "Agentic coding tool that lives in your terminal"
  homepage "https://github.com/anthropics/claude-code"
  url "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-2.0.60.tgz"
  sha256 "1a84fa97138386890ea9aa32ed03ffa537557502310c8f7bf1d33d182bda7914"
  # license :unfree

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8776a1a504ed8c7bbe895b5f59a1995facb77b50b812c81a9935ea173f38fdca"
    sha256 cellar: :any,                 arm64_sequoia: "fb9e0556a9484fb40e19365e5bdd0dd2f1c3a3bd0393c738ff9563d8ebd66f2e"
    sha256 cellar: :any,                 arm64_sonoma:  "fb9e0556a9484fb40e19365e5bdd0dd2f1c3a3bd0393c738ff9563d8ebd66f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c262775734ccdf7d749b984466bc1997d0a1dcc8b138711256e0c85df0ebe7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2e980d5d0b3ebc219b64b817ac44b588cb5fdae5cdeb8762cc567738978c69a"
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
